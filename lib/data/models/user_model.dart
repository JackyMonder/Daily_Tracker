/// Model đại diện cho một User trong ứng dụng Daily Tracker
/// 
/// User chứa thông tin xác thực và profile của người dùng.
class UserModel {
  /// ID duy nhất của user (thường là Firebase UID)
  final String id;

  /// Tên hiển thị của user
  final String name;

  /// Email của user (dùng để đăng nhập)
  final String email;

  /// Password đã được hash (chỉ lưu ở backend, không nên lưu ở client)
  /// Lưu ý: Field này chỉ nên có ở backend, client không nên lưu password
  final String? password;

  /// URL ảnh đại diện (optional)
  final String? avatarUrl;

  /// Thời gian tạo tài khoản
  final DateTime createdAt;

  /// Thời gian cập nhật profile lần cuối
  final DateTime updatedAt;

  /// Số điện thoại (optional)
  final String? phoneNumber;

  /// Trạng thái tài khoản (active, inactive, banned, etc.)
  final String status;

  /// Constructor chính
  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.password,
    this.avatarUrl,
    required this.createdAt,
    required this.updatedAt,
    this.phoneNumber,
    this.status = 'active',
  });

  /// Constructor để tạo user mới (tự động set createdAt và updatedAt)
  factory UserModel.create({
    required String name,
    required String email,
    String? phoneNumber,
    String? avatarUrl,
  }) {
    final now = DateTime.now();
    return UserModel(
      id: '', // Sẽ được set khi tạo trong Firebase Auth
      name: name,
      email: email,
      password: null, // Không lưu password ở client
      avatarUrl: avatarUrl,
      createdAt: now,
      updatedAt: now,
      phoneNumber: phoneNumber,
      status: 'active',
    );
  }

  /// Constructor từ Map (dùng khi đọc từ Firebase/JSON)
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String? ?? map['uid'] as String? ?? '',
      name: map['name'] as String? ?? map['displayName'] as String? ?? 'User',
      email: map['email'] as String? ?? '',
      password: map['password'] as String?, // Thường không có ở client
      avatarUrl: map['avatarUrl'] as String? ?? map['photoURL'] as String?,
      createdAt: _parseDateTime(map['createdAt']),
      updatedAt: _parseDateTime(map['updatedAt']),
      phoneNumber: map['phoneNumber'] as String?,
      status: map['status'] as String? ?? 'active',
    );
  }

  /// Constructor từ Firebase Auth User (tiện lợi khi tích hợp Firebase Auth)
  factory UserModel.fromFirebaseAuth({
    required String uid,
    String? email,
    String? displayName,
    String? photoURL,
    String? phoneNumber,
  }) {
    final now = DateTime.now();
    return UserModel(
      id: uid,
      name: displayName ?? 'User',
      email: email ?? '',
      avatarUrl: photoURL,
      createdAt: now,
      updatedAt: now,
      phoneNumber: phoneNumber,
      status: 'active',
    );
  }

  /// Chuyển đổi từ JSON string (cần import dart:convert để sử dụng)
  /// 
  /// Lưu ý: Phương thức này yêu cầu import 'dart:convert'
  /// Sử dụng: UserModel.fromJson(jsonDecode(jsonString))
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel.fromMap(json);
  }

  /// Chuyển đổi thành Map để lưu vào Firebase/JSON
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      if (avatarUrl != null) 'avatarUrl': avatarUrl,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      if (phoneNumber != null) 'phoneNumber': phoneNumber,
      'status': status,
      // Lưu ý: Không bao giờ serialize password ở client
    };
  }

  /// Chuyển đổi thành JSON string (cần import dart:convert để sử dụng)
  /// 
  /// Lưu ý: Phương thức này yêu cầu import 'dart:convert'
  /// Sử dụng: jsonEncode(userModel.toMap())
  Map<String, dynamic> toJson() {
    return toMap();
  }

  /// Copy với một số thay đổi
  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? password,
    String? avatarUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? phoneNumber,
    String? status,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      status: status ?? this.status,
    );
  }

  /// Helper method để parse DateTime từ nhiều format
  static DateTime _parseDateTime(dynamic value) {
    if (value == null) return DateTime.now();
    
    if (value is DateTime) return value;
    
    if (value is String) {
      try {
        return DateTime.parse(value);
      } catch (e) {
        return DateTime.now();
      }
    }
    
    if (value is int) {
      // Xử lý timestamp (milliseconds)
      return DateTime.fromMillisecondsSinceEpoch(value);
    }
    
    return DateTime.now();
  }

  /// Kiểm tra user có hợp lệ không
  bool get isValid {
    return id.isNotEmpty && 
           name.isNotEmpty && 
           email.isNotEmpty && 
           email.contains('@');
  }

  /// Override toString để debug
  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email, status: $status)';
  }

  /// Override equals để so sánh
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is UserModel &&
        other.id == id &&
        other.name == name &&
        other.email == email &&
        other.avatarUrl == avatarUrl &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.phoneNumber == phoneNumber &&
        other.status == status;
  }

  /// Override hashCode
  @override
  int get hashCode {
    return Object.hash(
      id,
      name,
      email,
      avatarUrl,
      createdAt,
      updatedAt,
      phoneNumber,
      status,
    );
  }
}

