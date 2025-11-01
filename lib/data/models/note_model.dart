/// Model đại diện cho một Note trong ứng dụng Daily Tracker
/// 
/// Note chứa thông tin về tiêu đề, nội dung và các thông tin metadata
/// như thời gian tạo, cập nhật và người sở hữu.
class NoteModel {
  /// ID duy nhất của note (thường từ Firebase)
  final String id;

  /// Tiêu đề của note
  final String title;

  /// Nội dung chi tiết của note
  final String content;

  /// ID của user sở hữu note này (optional để hỗ trợ multi-user sau này)
  final String? userId;

  /// Thời gian tạo note (ISO 8601 string hoặc timestamp)
  final DateTime createdAt;

  /// Thời gian cập nhật lần cuối (ISO 8601 string hoặc timestamp)
  final DateTime updatedAt;

  /// Màu sắc của note (optional - để hỗ trợ màu sắc tùy chỉnh)
  final int? colorValue;

  /// Trạng thái đã xóa hay chưa (soft delete)
  final bool isDeleted;

  /// Constructor chính
  NoteModel({
    required this.id,
    required this.title,
    required this.content,
    this.userId,
    required this.createdAt,
    required this.updatedAt,
    this.colorValue,
    this.isDeleted = false,
  });

  /// Constructor để tạo note mới (tự động set createdAt và updatedAt)
  factory NoteModel.create({
    required String title,
    required String content,
    String? userId,
    int? colorValue,
    DateTime? createdAt, 
  }) {
    final now = createdAt ?? DateTime.now();
    return NoteModel(
      id: '',
      title: title,
      content: content,
      userId: userId,
      createdAt: now,
      updatedAt: now,
      colorValue: colorValue,
      isDeleted: false,
    );
  }

  /// Constructor từ Map (dùng khi đọc từ Firebase/JSON)
  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
      id: map['id'] as String? ?? '',
      title: map['title'] as String? ?? 'Untitled',
      content: map['content'] as String? ?? '',
      userId: map['userId'] as String?,
      createdAt: _parseDateTime(map['createdAt']),
      updatedAt: _parseDateTime(map['updatedAt']),
      colorValue: map['colorValue'] as int?,
      isDeleted: map['isDeleted'] as bool? ?? false,
    );
  }

  /// Chuyển đổi từ JSON string (cần import dart:convert để sử dụng)
  /// 
  /// Lưu ý: Phương thức này yêu cầu import 'dart:convert'
  /// Sử dụng: NoteModel.fromJson(jsonDecode(jsonString))
  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel.fromMap(json);
  }

  /// Chuyển đổi thành Map để lưu vào Firebase/JSON
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      if (userId != null) 'userId': userId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      if (colorValue != null) 'colorValue': colorValue,
      'isDeleted': isDeleted,
    };
  }

  /// Chuyển đổi thành JSON string (cần import dart:convert để sử dụng)
  /// 
  /// Lưu ý: Phương thức này yêu cầu import 'dart:convert'
  /// Sử dụng: jsonEncode(noteModel.toMap())
  Map<String, dynamic> toJson() {
    return toMap();
  }

  /// Copy với một số thay đổi
  NoteModel copyWith({
    String? id,
    String? title,
    String? content,
    String? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? colorValue,
    bool? isDeleted,
  }) {
    return NoteModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      colorValue: colorValue ?? this.colorValue,
      isDeleted: isDeleted ?? this.isDeleted,
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

  /// Override toString để debug
  @override
  String toString() {
    return 'NoteModel(id: $id, title: $title, content: ${content.length > 20 ? content.substring(0, 20) + "..." : content}, createdAt: $createdAt)';
  }

  /// Override equals để so sánh
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is NoteModel &&
        other.id == id &&
        other.title == title &&
        other.content == content &&
        other.userId == userId &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.colorValue == colorValue &&
        other.isDeleted == isDeleted;
  }

  /// Override hashCode
  @override
  int get hashCode {
    return Object.hash(
      id,
      title,
      content,
      userId,
      createdAt,
      updatedAt,
      colorValue,
      isDeleted,
    );
  }
}

