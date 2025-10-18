// import 'dart:ffi';

import 'package:flutter/material.dart';
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
              final blocks = data['blocks'] as List<dynamic>?;

        // build excerpt from text blocks
              final excerpt = blocks != null
                  ? blocks.where((b) => b['type'] == 'text').map((t) => t['data']).join('\n')
                  : 'No Content';

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
                child: GestureDetector(
                  onTap: () async {
                    final result = await Navigator.of(context).push<Map<String, dynamic>>(
                      MaterialPageRoute(
                        builder: (_) => NoteEditorScreen(
                          initialTitle: data['title'] as String?,
                          initialBlocks: (data['blocks'] as List<dynamic>?)?.map((e) => Map<String, String>.from(e)).toList(),
                          heroTag: 'note-thumb-$index',
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
                  child: Material(
                    color: Colors.white,
                    elevation: 2,
                    borderRadius: BorderRadius.circular(14),
                    shadowColor: Colors.black.withOpacity(0.08),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: null,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // thumbnail removed on Home (images only shown in detail). show neutral box
                            Container(
                              height: 110,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Icon(Icons.note, color: Colors.grey.shade300, size: 36),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              data['title'] as String? ?? 'Untitled',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            Expanded(
                              child: Text(
                                excerpt,
                                style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}