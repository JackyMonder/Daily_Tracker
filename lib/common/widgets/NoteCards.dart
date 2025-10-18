// import 'dart:ffi';

import 'package:flutter/material.dart';

import '../../utils/notesection.dart';
import '../../presentation/screens/note_editor.dart';
import '../../data/note_store.dart';

class Notecards extends StatefulWidget {
  const Notecards({super.key});

  @override
  State<Notecards> createState() => _NotecardsState();
}

class _NotecardsState extends State<Notecards> {
  final NoteStore _store = NoteStore.instance;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ValueListenableBuilder<List<Map<String, dynamic>>>(
        valueListenable: _store.notes,
        builder: (context, notes, _) {
          if (notes.isEmpty) return const Center(child: Text('No Notes Available'));
          return GridView.builder(
            scrollDirection: Axis.vertical,
            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.9,
            ),
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final data = notes[index];
              // find first image block for thumbnail
              String? thumb;
              final blocks = data['blocks'] as List<dynamic>?;
              if (blocks != null) {
                for (final b in blocks) {
                  if (b is Map && b['type'] == 'image' && (b['data'] as String).isNotEmpty) {
                    thumb = b['data'] as String;
                    break;
                  }
                }
              }

              return Notesection(
                noteTitle: data['title'] as String? ?? 'Untitled',
                noteContent: blocks != null
                    ? blocks.where((b) => b['type'] == 'text').map((t) => t['data']).join('\n')
                    : 'No Content',
                thumbnailPath: thumb,
                onTapEdit: () async {
                  final result = await Navigator.of(context).push<Map<String, dynamic>>(
                    MaterialPageRoute(
                      builder: (_) => NoteEditorScreen(
                        initialTitle: data['title'] as String?,
                        initialBlocks: (data['blocks'] as List<dynamic>?)?.map((e) => Map<String, String>.from(e)).toList(),
                      ),
                    ),
                  );
                  if (result is Map<String, dynamic>) {
                    if (result['delete'] == true) {
                      _store.removeNote(index);
                    } else if (result.containsKey('blocks')) {
                      // updated note
                      final updated = {
                        'title': (result['title'] as String?)?.trim() ?? data['title'],
                        'blocks': (result['blocks'] as List<dynamic>).map((e) => Map<String, String>.from(e)).toList(),
                      };
                      _store.updateNote(index, updated);
                    }
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}