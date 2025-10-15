import 'package:flutter/material.dart';

class Notesection extends StatelessWidget {
  final String noteTitle;
  final String noteContent;
  Function(bool?)? onChanged; // This element gonna be used latter (SAVE CHANGED METHOD)

  Notesection ({
    super.key, 
    required this.noteTitle, 
    required this.noteContent
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              noteTitle,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  noteContent,
                  style: const TextStyle(fontSize: 14),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}