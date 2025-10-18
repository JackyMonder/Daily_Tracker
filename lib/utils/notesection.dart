import 'dart:io';

import 'package:flutter/material.dart';
import 'package:expenses_app/presentation/screens/note_editor.dart';

class Notesection extends StatelessWidget {
  final String noteTitle;
  final String noteContent;
  final String? thumbnailPath;
  final VoidCallback? onTapEdit;
  final Function(bool?)? onChanged; // This element gonna be used latter (SAVE CHANGED METHOD)

  Notesection ({
    super.key,
    required this.noteTitle,
    required this.noteContent,
    this.thumbnailPath,
    this.onTapEdit,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTapEdit ?? () {
        final blocks = <Map<String, String>>[];
        if (noteContent.isNotEmpty) blocks.add({'type': 'text', 'data': noteContent});
        if (thumbnailPath != null && thumbnailPath!.isNotEmpty) blocks.add({'type': 'image', 'data': thumbnailPath!});
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => NoteEditorScreen(
              initialTitle: noteTitle,
              initialBlocks: blocks,
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
              if (thumbnailPath != null && thumbnailPath!.isNotEmpty) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(
                    File(thumbnailPath!),
                    width: double.infinity,
                    height: 90,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 8),
              ],
              Text(
                noteTitle,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Flexible(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    noteContent,
                    style: const TextStyle(fontSize: 14, height: 1.3),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}