import 'dart:async';
import '../../core/services/firebase_database_service.dart';
import '../models/user_model.dart';

/// Repository quản lý CRUD operations cho User với Firebase Realtime Database
/// 
/// Lưu ý: Firebase Auth quản lý authentication (email, password)
/// Repository này quản lý thông tin bổ sung của user trong Realtime Database
/// Format dữ liệu khớp với firebase_sample_data.json
class UserRepository {
  static const String _usersPath = 'users';

  /// Lấy thông tin user theo ID
  /// 
  /// [userId] - ID của user (Firebase UID)
  Future<UserModel?> getUserById(String userId) async {
    try {
      final ref = FirebaseDatabaseService.ref('$_usersPath/$userId');
      
      // Thêm timeout để không block quá lâu
      final snapshot = await ref.get().timeout(
        const Duration(seconds: 3),
        onTimeout: () {
          print('⚠ Timeout getting user $userId - returning null');
          throw TimeoutException('Get user timeout');
        },
      );

      if (!snapshot.exists || snapshot.value == null) {
        return null;
      }

      final data = Map<String, dynamic>.from(snapshot.value as Map);
      data['id'] = userId; // Đảm bảo có id trong data

      return UserModel.fromMap(data);
    } on TimeoutException {
      // Timeout - trả về null để không block flow
      return null;
    } catch (e) {
      print('Error getting user by ID: $e');
      // Không rethrow để không block login flow
      return null;
    }
  }

  /// Lấy thông tin user theo email
  /// 
  /// [email] - Email của user
  /// 
  /// Lưu ý: Firebase Realtime Database không có query như Firestore
  /// Nên cần lấy tất cả users rồi filter (không hiệu quả với dữ liệu lớn)
  Future<UserModel?> getUserByEmail(String email) async {
    try {
      final allUsers = await getAllUsers();
      return allUsers.firstWhere(
        (user) => user.email.toLowerCase() == email.toLowerCase(),
        orElse: () => throw Exception('User not found'),
      );
    } catch (e) {
      return null;
    }
  }

  /// Lấy tất cả users
  /// 
  /// Lưu ý: Chỉ trả về users có status 'active'
  Future<List<UserModel>> getAllUsers() async {
    try {
      final ref = FirebaseDatabaseService.ref(_usersPath);
      final snapshot = await ref.get();

      if (!snapshot.exists || snapshot.value == null) {
        return [];
      }

      final data = snapshot.value as Map<dynamic, dynamic>;
      final users = <UserModel>[];

      data.forEach((key, value) {
        try {
          final userMap = Map<String, dynamic>.from(value as Map);
          userMap['id'] = key.toString();

          final user = UserModel.fromMap(userMap);

          // Chỉ trả về users có status active
          if (user.status == 'active') {
            users.add(user);
          }
        } catch (e) {
          // Skip invalid users
          print('Error parsing user $key: $e');
        }
      });

      return users;
    } catch (e) {
      print('Error getting all users: $e');
      rethrow;
    }
  }

  /// Tạo user mới trong Realtime Database
  /// 
  /// [user] - UserModel với thông tin user
  /// 
  /// Lưu ý: userId phải là Firebase UID từ Firebase Auth
  /// Format khớp với firebase_sample_data.json:
  /// - displayName (thay vì name)
  /// - email
  /// - createdAt
  /// - updatedAt
  /// - avatarUrl (optional)
  /// - status
  Future<UserModel> createUser(UserModel user) async {
    try {
      if (user.id.isEmpty) {
        throw Exception('User ID cannot be empty');
      }

      if (user.email.isEmpty) {
        throw Exception('User email cannot be empty');
      }

      final path = '$_usersPath/${user.id}';
      print('=== Creating user in Firebase ===');
      print('User ID: ${user.id}');
      print('User email: ${user.email}');
      print('User name: ${user.name}');
      print('Database path: $path');
      
      final ref = FirebaseDatabaseService.ref(path);
      print('Database URL: ${FirebaseDatabaseService.instance.databaseURL ?? "default"}');

      // Tạo user với timestamps
      final now = DateTime.now();
      final userToSave = user.copyWith(
        createdAt: now,
        updatedAt: now,
      );

      // Tạo map để lưu vào Firebase với format khớp firebase_sample_data.json
      // Không lưu 'id' vì id đã là key trong path
      // Dùng 'displayName' thay vì 'name' để khớp với sample data
      final userMap = <String, dynamic>{
        'email': userToSave.email,
        'displayName': userToSave.name.isNotEmpty ? userToSave.name : 'User',
        'createdAt': userToSave.createdAt.toIso8601String(),
        'updatedAt': userToSave.updatedAt.toIso8601String(),
        'status': userToSave.status,
      };

      // Chỉ thêm các field optional nếu có giá trị
      if (userToSave.avatarUrl != null && userToSave.avatarUrl!.isNotEmpty) {
        userMap['avatarUrl'] = userToSave.avatarUrl;
      } else {
        userMap['avatarUrl'] = null; // Khớp với sample data format
      }

      if (userToSave.phoneNumber != null && userToSave.phoneNumber!.isNotEmpty) {
        userMap['phoneNumber'] = userToSave.phoneNumber;
      }

      print('User data to save: $userMap');
      print('Attempting to write to Firebase...');
      
      // Ghi vào Firebase với timeout dài hơn để tránh timeout
      // Dùng unawaited để không block nếu timeout
      try {
        await ref.set(userMap).timeout(
          const Duration(seconds: 15),
          onTimeout: () {
            print('⚠ Write timeout after 15s - trying unawaited write');
            // Thử write không await để không block
            ref.set(userMap).catchError((e) {
              print('Unawaited write also failed: $e');
            });
            throw Exception('Firebase write timeout - data may still be saved');
          },
        );
        
        print('✓ User data written successfully!');
      } catch (e) {
        // Log nhưng không throw để không block flow
        if (e.toString().contains('timeout')) {
          print('⚠ Timeout writing user - may have been saved anyway');
          // Không throw để flow tiếp tục
        } else {
          rethrow;
        }
      }

      return userToSave;
    } catch (e) {
      print('Error creating user: $e');
      rethrow;
    }
  }

  /// Cập nhật thông tin user
  /// 
  /// [userId] - ID của user cần cập nhật
  /// [user] - UserModel với thông tin cập nhật
  Future<UserModel> updateUser(String userId, UserModel user) async {
    try {
      final ref = FirebaseDatabaseService.ref('$_usersPath/$userId');

      // Cập nhật với updatedAt mới
      final updatedUser = user.copyWith(
        id: userId,
        updatedAt: DateTime.now(),
      );

      // Tạo map để update với format khớp firebase_sample_data.json
      final updateMap = <String, dynamic>{
        'email': updatedUser.email,
        'displayName': updatedUser.name.isNotEmpty ? updatedUser.name : 'User',
        'updatedAt': updatedUser.updatedAt.toIso8601String(),
        'status': updatedUser.status,
      };

      // Chỉ update các field có giá trị
      if (updatedUser.avatarUrl != null && updatedUser.avatarUrl!.isNotEmpty) {
        updateMap['avatarUrl'] = updatedUser.avatarUrl;
      } else {
        updateMap['avatarUrl'] = null;
      }

      if (updatedUser.phoneNumber != null && updatedUser.phoneNumber!.isNotEmpty) {
        updateMap['phoneNumber'] = updatedUser.phoneNumber;
      }

      await ref.update(updateMap);

      return updatedUser;
    } catch (e) {
      print('Error updating user: $e');
      rethrow;
    }
  }

  /// Xóa user (soft delete)
  /// 
  /// [userId] - ID của user cần xóa
  Future<void> deleteUser(String userId) async {
    try {
      final ref = FirebaseDatabaseService.ref('$_usersPath/$userId');
      
      // Soft delete: chỉ set status = 'inactive'
      await ref.update({
        'status': 'inactive',
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print('Error deleting user: $e');
      rethrow;
    }
  }

  /// Xóa vĩnh viễn user
  /// 
  /// [userId] - ID của user cần xóa vĩnh viễn
  Future<void> deleteUserPermanently(String userId) async {
    try {
      final ref = FirebaseDatabaseService.ref('$_usersPath/$userId');
      await ref.remove();
    } catch (e) {
      print('Error permanently deleting user: $e');
      rethrow;
    }
  }
}

