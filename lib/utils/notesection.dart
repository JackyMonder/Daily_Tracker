import 'package:flutter/material.dart';
import 'package:expenses_app/presentation/screens/note_editor.dart';

class Notesection extends StatelessWidget {
  final String noteTitle;
  final String noteContent;
  // Function(bool?)? onChanged; // This element gonna be used latter (SAVE CHANGED METHOD)

  Notesection ({
    super.key, 
    required this.noteTitle, 
    required this.noteContent
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => NoteEditorScreen(
              initialTitle: noteTitle,
              initialContent: noteContent,
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
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                noteTitle,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  noteContent,
                  style: const TextStyle(fontSize: 14, height: 1.3),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}