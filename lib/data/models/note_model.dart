class NoteModel {
  final String id;
  final String title;
  final String content;
  final String? deltaContent;
  final String? userId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int? colorValue;
  final bool isDeleted;

  NoteModel({
    required this.id,
    required this.title,
    required this.content,
    this.deltaContent,
    this.userId,
    required this.createdAt,
    required this.updatedAt,
    this.colorValue,
    this.isDeleted = false,
  });

  factory NoteModel.create({
    required String title,
    required String content,
    String? deltaContent,
    String? userId,
    int? colorValue,
    DateTime? createdAt, 
  }) {
    final now = createdAt ?? DateTime.now();
    return NoteModel(
      id: '',
      title: title,
      content: content,
      deltaContent: deltaContent,
      userId: userId,
      createdAt: now,
      updatedAt: now,
      colorValue: colorValue,
      isDeleted: false,
    );
  }

  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
      id: map['id'] as String? ?? '',
      title: map['title'] as String? ?? 'Untitled',
      content: map['content'] as String? ?? '',
      deltaContent: map['deltaContent'] as String?,
      userId: map['userId'] as String?,
      createdAt: _parseDateTime(map['createdAt']),
      updatedAt: _parseDateTime(map['updatedAt']),
      colorValue: map['colorValue'] as int?,
      isDeleted: map['isDeleted'] as bool? ?? false,
    );
  }

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel.fromMap(json);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      if (deltaContent != null) 'deltaContent': deltaContent,
      if (userId != null) 'userId': userId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      if (colorValue != null) 'colorValue': colorValue,
      'isDeleted': isDeleted,
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  NoteModel copyWith({
    String? id,
    String? title,
    String? content,
    String? deltaContent,
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
      deltaContent: deltaContent ?? this.deltaContent,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      colorValue: colorValue ?? this.colorValue,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

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
      return DateTime.fromMillisecondsSinceEpoch(value);
    }
    
    return DateTime.now();
  }

  @override
  String toString() {
    return 'NoteModel(id: $id, title: $title, content: ${content.length > 20 ? content.substring(0, 20) + "..." : content}, createdAt: $createdAt)';
  }

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

