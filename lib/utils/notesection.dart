import 'package:flutter/material.dart';
import 'package:daily_tracker/presentation/screens/note_editor.dart';
import 'package:daily_tracker/data/models/note_model.dart';

class Notesection extends StatelessWidget {
  final NoteModel note;
  final VoidCallback? onTap;

  Notesection({
    super.key,
    required this.note,
    this.onTap,
  });

  /// Lấy màu cho note card
  Color _getNoteColor() {
    if (note.colorValue != null) {
      return Color(note.colorValue!);
    }
    // Màu mặc định
    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    final noteColor = _getNoteColor();
    final isColored = note.colorValue != null;

    return InkWell(
      onTap: onTap ?? () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => NoteEditorScreen(
              noteId: note.id,
              initialTitle: note.title,
              initialContent: note.content,
              initialColorValue: note.colorValue,
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Card(
        clipBehavior: Clip.antiAlias,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 3,
        shadowColor: Colors.black.withValues(alpha: 0.08),
        color: isColored ? noteColor.withOpacity(0.1) : null,
        child: Container(
          decoration: isColored
              ? BoxDecoration(
                  border: Border.all(
                    color: noteColor.withOpacity(0.3),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(16),
                )
              : null,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        note.title.isEmpty ? 'Untitled' : note.title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: isColored ? noteColor : null,
                        ),
                      ),
                    ),
                    if (isColored)
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: noteColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    note.content.isEmpty ? 'No content' : note.content,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.3,
                      color: isColored
                          ? noteColor.withOpacity(0.8)
                          : Colors.black87,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 8),
                // Hiển thị ngày tạo
                Text(
                  _formatDate(note.createdAt),
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.withOpacity(0.7),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final noteDate = DateTime(date.year, date.month, date.day);

    if (noteDate == today) {
      return 'Today';
    } else if (noteDate == today.subtract(const Duration(days: 1))) {
      return 'Yesterday';
    } else {
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ];
      return '${date.day} ${months[date.month - 1]} ${date.year}';
    }
  }
}