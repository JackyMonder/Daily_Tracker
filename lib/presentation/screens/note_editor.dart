import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class NoteEditorScreen extends StatefulWidget {
  final String? initialTitle;
  final List<Map<String, String>>? initialBlocks;

  const NoteEditorScreen({super.key, this.initialTitle, this.initialBlocks});

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  late final TextEditingController _titleController;
  List<Map<String, String>> _blocks = [];
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle ?? '');
    if (widget.initialBlocks != null && widget.initialBlocks!.isNotEmpty) {
      _blocks = List<Map<String, String>>.from(widget.initialBlocks!);
    } else {
      _blocks = [
        {'type': 'text', 'data': ''},
      ];
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _saveAndPop() {
    Navigator.of(context).pop({
      'title': _titleController.text.trim(),
      'blocks': _blocks,
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? picked = await _picker.pickImage(source: source, imageQuality: 80);
      if (picked != null) {
        setState(() => _blocks.add({'type': 'image', 'data': picked.path}));
      }
    } catch (e) {
      // ignore errors for now
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        title: const Text(
          'Edit Note',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Delete note'),
                  content: const Text('Are you sure you want to delete this note? This action cannot be undone.'),
                  actions: [
                    TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancel')),
                    TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Delete')),
                  ],
                ),
              );
              if (confirmed == true) Navigator.of(context).pop({'delete': true});
            },
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Delete',
          ),
          IconButton(
            onPressed: _saveAndPop,
            icon: const Icon(Icons.check),
            tooltip: 'Save',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
              decoration: InputDecoration(
                hintText: 'Title',
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.grey[400]),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                TextButton.icon(
                  onPressed: () => setState(() => _blocks.add({'type': 'text', 'data': ''})),
                  icon: const Icon(Icons.text_fields),
                  label: const Text('Text'),
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: () => _pickImage(ImageSource.gallery),
                  icon: const Icon(Icons.photo),
                  label: const Text('Image'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ReorderableListView.builder(
                itemCount: _blocks.length,
                onReorder: (oldIndex, newIndex) {
                  setState(() {
                    if (newIndex > oldIndex) newIndex -= 1;
                    final item = _blocks.removeAt(oldIndex);
                    _blocks.insert(newIndex, item);
                  });
                },
                itemBuilder: (context, idx) {
                  final block = _blocks[idx];
                  if (block['type'] == 'image') {
                    return ListTile(
                      key: ValueKey('img_$idx'),
                      title: block['data'] != null && block['data']!.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(File(block['data']!), height: 180, fit: BoxFit.cover),
                            )
                          : const Text('No image'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => setState(() => _blocks.removeAt(idx)),
                      ),
                    );
                  }
                  // text block
                  return ListTile(
                    key: ValueKey('txt_$idx'),
                    title: _TextBlockField(
                      initial: block['data'] ?? '',
                      onChanged: (v) => block['data'] = v,
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => setState(() => _blocks.removeAt(idx)),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TextBlockField extends StatefulWidget {
  final String initial;
  final ValueChanged<String> onChanged;
  const _TextBlockField({required this.initial, required this.onChanged, Key? key}) : super(key: key);

  @override
  State<_TextBlockField> createState() => _TextBlockFieldState();
}

class _TextBlockFieldState extends State<_TextBlockField> {
  late final TextEditingController _controller;
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initial);
    _controller.addListener(() => widget.onChanged(_controller.text));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      decoration: const InputDecoration(border: InputBorder.none, hintText: 'Text block'),
      maxLines: null,
    );
  }
}



