import '../../core/services/firebase_database_service.dart';
import '../models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Repository quản lý CRUD operations cho User với Firebase Realtime Database
class UserRepository {
  static const String _usersPath = 'users';

  /// Lưu user profile vào Realtime Database
  /// 
  /// [user] - User từ Firebase Auth
  /// [name] - Tên hiển thị (optional, sẽ dùng email nếu không có)
  Future<void> saveUserProfile(User user, {String? name}) async {
    try {
      final ref = FirebaseDatabaseService.ref('$_usersPath/${user.uid}');
      
      // Kiểm tra xem user đã tồn tại chưa
      final snapshot = await ref.get();
      
      // Nếu user đã tồn tại, chỉ cập nhật updatedAt
      if (snapshot.exists && snapshot.value != null) {
        await ref.update({
          'updatedAt': DateTime.now().toIso8601String(),
          'email': user.email ?? '',
          if (user.displayName != null) 'name': user.displayName,
          if (name != null) 'name': name,
        });
        return;
      }

      // Tạo user profile mới
      final userModel = UserModel.fromFirebaseAuth(
        uid: user.uid,
        email: user.email,
        displayName: name ?? user.displayName,
        photoURL: user.photoURL,
        phoneNumber: user.phoneNumber,
      );

      // Lưu vào Firebase
      await ref.set(userModel.toMap());
    } catch (e) {
      print('Error saving user profile: $e');
      rethrow;
    }
  }

  /// Lấy user profile từ Realtime Database
  /// 
  /// [userId] - ID của user (Firebase UID)
  Future<UserModel?> getUserProfile(String userId) async {
    try {
      final ref = FirebaseDatabaseService.ref('$_usersPath/$userId');
      final snapshot = await ref.get();

      if (!snapshot.exists || snapshot.value == null) {
        return null;
      }

      final data = Map<String, dynamic>.from(snapshot.value as Map);
      data['id'] = userId;

      return UserModel.fromMap(data);
    } catch (e) {
      print('Error getting user profile: $e');
      return null;
    }
  }

  /// Cập nhật user profile
  /// 
  /// [userId] - ID của user
  /// [userModel] - UserModel với thông tin cần cập nhật
  Future<void> updateUserProfile(String userId, UserModel userModel) async {
    try {
      final ref = FirebaseDatabaseService.ref('$_usersPath/$userId');
      
      final updatedUser = userModel.copyWith(
        id: userId,
        updatedAt: DateTime.now(),
      );

      await ref.update(updatedUser.toMap());
    } catch (e) {
      print('Error updating user profile: $e');
      rethrow;
    }
  }

  /// Xóa user profile (khi xóa tài khoản)
  /// 
  /// [userId] - ID của user
  Future<void> deleteUserProfile(String userId) async {
    try {
      final ref = FirebaseDatabaseService.ref('$_usersPath/$userId');
      await ref.remove();
    } catch (e) {
      print('Error deleting user profile: $e');
      rethrow;
    }
  }
}

