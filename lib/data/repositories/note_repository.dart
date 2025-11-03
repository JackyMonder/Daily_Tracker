import '../../core/services/firebase_database_service.dart';
import '../models/note_model.dart';

/// Repository quản lý CRUD operations cho Note với Firebase Realtime Database
class NoteRepository {
  static const String _notesPath = 'notes';

  /// Lấy tất cả notes
  /// 
  /// [userId] - ID của user (optional, nếu có thì chỉ lấy notes của user đó)
  Future<List<NoteModel>> getAllNotes({String? userId}) async {
    try {
      final ref = FirebaseDatabaseService.ref(_notesPath);
      final snapshot = await ref.get();

      if (!snapshot.exists || snapshot.value == null) {
        return [];
      }

      final data = snapshot.value as Map<dynamic, dynamic>;
      final notes = <NoteModel>[];

      data.forEach((key, value) {
        try {
          final noteMap = Map<String, dynamic>.from(value as Map);
          noteMap['id'] = key.toString();

          final note = NoteModel.fromMap(noteMap);

          // Lọc theo userId - BẮT BUỘC phải có userId và phải trùng khớp
          // Không lấy notes có userId null hoặc khác userId hiện tại
          if (userId != null && note.userId != null && note.userId == userId) {
            // Chỉ trả về notes chưa bị xóa
            if (!note.isDeleted) {
              notes.add(note);
            }
          } else if (userId == null && note.userId == null) {
            // Trường hợp đặc biệt: không có user (không nên xảy ra nếu đã login)
            // Nhưng để tương thích với data cũ
            if (!note.isDeleted) {
              notes.add(note);
            }
          }
        } catch (e) {
          // Skip invalid notes
          print('Error parsing note $key: $e');
        }
      });

      // Sắp xếp theo createdAt (mới nhất trước)
      notes.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return notes;
    } catch (e) {
      print('Error getting all notes: $e');
      rethrow;
    }
  }

  /// Lấy note theo ID
  Future<NoteModel?> getNoteById(String noteId) async {
    try {
      final ref = FirebaseDatabaseService.ref('$_notesPath/$noteId');
      final snapshot = await ref.get();

      if (!snapshot.exists || snapshot.value == null) {
        return null;
      }

      final data = Map<String, dynamic>.from(snapshot.value as Map);
      data['id'] = noteId;

      return NoteModel.fromMap(data);
    } catch (e) {
      print('Error getting note by ID: $e');
      rethrow;
    }
  }

  /// Lấy notes theo ngày
  /// 
  /// [date] - Ngày cần lấy notes
  /// [userId] - ID của user (optional)
  Future<List<NoteModel>> getNotesByDate(DateTime date, {String? userId}) async {
    try {
      final allNotes = await getAllNotes(userId: userId);

      return allNotes.where((note) {
        final noteDate = note.createdAt;
        return noteDate.year == date.year &&
               noteDate.month == date.month &&
               noteDate.day == date.day;
      }).toList();
    } catch (e) {
      print('Error getting notes by date: $e');
      rethrow;
    }
  }

  /// Tạo note mới
  /// 
  /// Trả về note đã được tạo với ID từ Firebase
  Future<NoteModel> createNote(NoteModel note) async {
    try {
      final ref = FirebaseDatabaseService.ref(_notesPath);
      
      // Tạo note mới với ID tự động từ Firebase
      final newNoteRef = ref.push();
      final noteId = newNoteRef.key!;

      // Tạo note với ID và timestamps
      // Giữ nguyên createdAt nếu đã được set (khi user chọn ngày), nếu không thì dùng DateTime.now()
      final now = DateTime.now();
      final noteToSave = note.copyWith(
        id: noteId,
        createdAt: note.createdAt, // Giữ nguyên createdAt từ note (có thể là ngày được chọn)
        updatedAt: now,
      );

      // Lưu vào Firebase
      await newNoteRef.set(noteToSave.toMap());

      return noteToSave;
    } catch (e) {
      print('Error creating note: $e');
      rethrow;
    }
  }

  /// Cập nhật note
  /// 
  /// [noteId] - ID của note cần cập nhật
  /// [note] - Note với các thông tin cần cập nhật
  Future<NoteModel> updateNote(String noteId, NoteModel note) async {
    try {
      final ref = FirebaseDatabaseService.ref('$_notesPath/$noteId');

      // Cập nhật note với updatedAt mới
      final updatedNote = note.copyWith(
        id: noteId,
        updatedAt: DateTime.now(),
      );

      await ref.update(updatedNote.toMap());

      return updatedNote;
    } catch (e) {
      print('Error updating note: $e');
      rethrow;
    }
  }

  /// Xóa note (soft delete)
  /// 
  /// [noteId] - ID của note cần xóa
  Future<void> deleteNote(String noteId) async {
    try {
      final ref = FirebaseDatabaseService.ref('$_notesPath/$noteId');
      
      // Soft delete: chỉ set isDeleted = true
      await ref.update({
        'isDeleted': true,
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print('Error deleting note: $e');
      rethrow;
    }
  }

  /// Xóa vĩnh viễn note
  /// 
  /// [noteId] - ID của note cần xóa vĩnh viễn
  Future<void> deleteNotePermanently(String noteId) async {
    try {
      final ref = FirebaseDatabaseService.ref('$_notesPath/$noteId');
      await ref.remove();
    } catch (e) {
      print('Error permanently deleting note: $e');
      rethrow;
    }
  }

  /// Lắng nghe thay đổi realtime của notes
  /// 
  /// [userId] - ID của user (BẮT BUỘC, để filter notes theo user)
  /// Trả về Stream để lắng nghe các thay đổi
  Stream<List<NoteModel>> watchNotes({required String? userId}) {
    try {
      final ref = FirebaseDatabaseService.ref(_notesPath);
      
      return ref.onValue.map((event) {
        if (!event.snapshot.exists || event.snapshot.value == null) {
          return <NoteModel>[];
        }

        final data = event.snapshot.value as Map<dynamic, dynamic>;
        final notes = <NoteModel>[];

        data.forEach((key, value) {
          try {
            final noteMap = Map<String, dynamic>.from(value as Map);
            noteMap['id'] = key.toString();

            final note = NoteModel.fromMap(noteMap);

            // Lọc theo userId - BẮT BUỘC phải có userId và phải trùng khớp
            // Không lấy notes có userId null hoặc khác userId hiện tại
            if (userId != null && note.userId != null && note.userId == userId) {
              // Chỉ trả về notes chưa bị xóa
              if (!note.isDeleted) {
                notes.add(note);
              }
            }
            // Nếu userId == null (không nên xảy ra khi đã login), không trả về notes nào
          } catch (e) {
            // Skip invalid notes
            print('Error parsing note $key: $e');
          }
        });

        // Sắp xếp theo createdAt (mới nhất trước)
        notes.sort((a, b) => b.createdAt.compareTo(a.createdAt));

        return notes;
      });
    } catch (e) {
      print('Error watching notes: $e');
      return Stream.value([]);
    }
  }

  /// Lấy danh sách các ngày có notes
  /// 
  /// [userId] - ID của user (BẮT BUỘC để filter notes theo user)
  Future<List<DateTime>> getNotesDates({required String? userId}) async {
    try {
      if (userId == null) {
        // Không có userId, không thể lấy notes
        return [];
      }
      
      final notes = await getAllNotes(userId: userId);
      final dates = <DateTime>[];

      for (final note in notes) {
        final date = DateTime(
          note.createdAt.year,
          note.createdAt.month,
          note.createdAt.day,
        );
        
        // Chỉ thêm nếu chưa có trong danh sách
        if (!dates.any((d) => d.year == date.year && 
                             d.month == date.month && 
                             d.day == date.day)) {
          dates.add(date);
        }
      }

      return dates;
    } catch (e) {
      print('Error getting notes dates: $e');
      return [];
    }
  }

  /// Lấy số lượng notes đã xóa (soft delete)
  /// 
  /// [userId] - ID của user (BẮT BUỘC để filter notes theo user)
  Future<int> getDeletedNotesCount({required String? userId}) async {
    try {
      if (userId == null) {
        return 0;
      }

      final ref = FirebaseDatabaseService.ref(_notesPath);
      final snapshot = await ref.get();

      if (!snapshot.exists || snapshot.value == null) {
        return 0;
      }

      final data = snapshot.value as Map<dynamic, dynamic>;
      int deletedCount = 0;

      data.forEach((key, value) {
        try {
          final noteMap = Map<String, dynamic>.from(value as Map);
          noteMap['id'] = key.toString();

          final note = NoteModel.fromMap(noteMap);

          // Chỉ đếm notes của user hiện tại và đã bị xóa
          if (note.userId != null && note.userId == userId) {
            if (note.isDeleted) {
              deletedCount++;
            }
          }
        } catch (e) {
          // Skip invalid notes
          print('Error parsing note $key: $e');
        }
      });

      return deletedCount;
    } catch (e) {
      print('Error getting deleted notes count: $e');
      return 0;
    }
  }

  /// Stream lắng nghe số lượng notes đã xóa (real-time)
  /// 
  /// [userId] - ID của user (BẮT BUỘC để filter notes theo user)
  Stream<int> watchDeletedNotesCount({required String? userId}) {
    try {
      if (userId == null) {
        return Stream.value(0);
      }

      final ref = FirebaseDatabaseService.ref(_notesPath);
      
      return ref.onValue.map((event) {
        if (!event.snapshot.exists || event.snapshot.value == null) {
          return 0;
        }

        final data = event.snapshot.value as Map<dynamic, dynamic>;
        int deletedCount = 0;

        data.forEach((key, value) {
          try {
            final noteMap = Map<String, dynamic>.from(value as Map);
            noteMap['id'] = key.toString();

            final note = NoteModel.fromMap(noteMap);

            // Chỉ đếm notes của user hiện tại và đã bị xóa
            if (note.userId != null && note.userId == userId) {
              if (note.isDeleted) {
                deletedCount++;
              }
            }
          } catch (e) {
            // Skip invalid notes
            print('Error parsing note $key: $e');
          }
        });

        return deletedCount;
      });
    } catch (e) {
      print('Error watching deleted notes count: $e');
      return Stream.value(0);
    }
  }
}

