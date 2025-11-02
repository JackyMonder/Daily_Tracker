import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'dart:convert';
import '../../data/models/note_model.dart';
import '../../data/repositories/note_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NoteEditorScreen extends StatefulWidget {
  final String? noteId;
  final String? initialTitle;
  final String? initialContent;
  final int? initialColorValue;
  final DateTime? selectedDate;

  const NoteEditorScreen({
    super.key,
    this.noteId,
    this.initialTitle,
    this.initialContent,
    this.initialColorValue,
    this.selectedDate,
  });

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  late final TextEditingController _titleController;
  late final QuillController _quillController;
  late final FocusNode _titleFocusNode;
  late final FocusNode _quillFocusNode;
  late final ScrollController _scrollController;

  final NoteRepository _noteRepository = NoteRepository();
  bool _isSaving = false;
  bool _isDeleting = false;
  int? _selectedColorValue;

  final List<Color> _availableColors = [
    Colors.red.shade300,
    Colors.pink.shade300,
    Colors.purple.shade300,
    Colors.deepPurple.shade300,
    Colors.indigo.shade300,
    Colors.blue.shade300,
    Colors.lightBlue.shade300,
    Colors.cyan.shade300,
    Colors.teal.shade300,
    Colors.green.shade300,
    Colors.lightGreen.shade300,
    Colors.lime.shade300,
    Colors.yellow.shade300,
    Colors.amber.shade300,
    Colors.orange.shade300,
    Colors.deepOrange.shade300,
    Colors.brown.shade300,
    Colors.grey.shade400,
  ];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle ?? '');
    _titleFocusNode = FocusNode();
    _quillFocusNode = FocusNode();
    _scrollController = ScrollController();
    _selectedColorValue = widget.initialColorValue;

    _quillController = QuillController.basic();
    
    if (widget.initialContent != null && widget.initialContent!.isNotEmpty) {
      try {
        final deltaJson = jsonDecode(widget.initialContent!);
        _quillController.document = Document.fromJson(deltaJson);
      } catch (e) {
        _quillController.document.insert(0, widget.initialContent!);
      }
    }

    if (widget.noteId == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _titleFocusNode.requestFocus();
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _quillController.dispose();
    _titleFocusNode.dispose();
    _quillFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _saveNote() async {
    final title = _titleController.text.trim();
    final plainText = _quillController.document.toPlainText().trim();
    final deltaJson = jsonEncode(_quillController.document.toDelta().toJson());

    if (title.isEmpty && plainText.isEmpty) {
      Navigator.of(context).pop();
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw 'Bạn cần đăng nhập để tạo note';
      }
      final userId = user.uid;

      if (widget.noteId != null) {
        final existingNote = await _noteRepository.getNoteById(widget.noteId!);
        if (existingNote != null) {
          final updatedNote = existingNote.copyWith(
            title: title.isEmpty ? 'Untitled' : title,
            content: plainText,
            deltaContent: deltaJson,
            userId: userId,
            updatedAt: DateTime.now(),
          );
          await _noteRepository.updateNote(widget.noteId!, updatedNote);
        }
      } else {
        final createdAt = widget.selectedDate ?? DateTime.now();
        final newNote = NoteModel.create(
          title: title.isEmpty ? 'Untitled' : title,
          content: plainText,
          deltaContent: deltaJson,
          userId: userId,
          colorValue: _selectedColorValue,
          createdAt: createdAt,
        );
        await _noteRepository.createNote(newNote);
      }

      if (mounted) {
        setState(() {
          _isSaving = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.noteId != null ? 'Note updated' : 'Note created'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving note: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> _deleteNote() async {
    if (widget.noteId == null) {
      Navigator.of(context).pop();
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Note'),
        content: const Text('Are you sure you want to delete this note?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() {
        _isDeleting = true;
      });

      try {
        await _noteRepository.deleteNote(widget.noteId!);
        if (mounted) {
          setState(() {
            _isDeleting = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Note deleted'),
              backgroundColor: Colors.orange,
              duration: Duration(seconds: 2),
            ),
          );
          Navigator.of(context).pop(true);
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _isDeleting = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error deleting note: $e'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
          padding: const EdgeInsets.only(left: 8),
        ),
        title: TextField(
          controller: _titleController,
          focusNode: _titleFocusNode,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
            height: 1.2,
          ),
          decoration: const InputDecoration(
            hintText: 'Tiêu đề ghi chú',
            hintStyle: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w400,
              fontSize: 18,
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 8),
          ),
          textInputAction: TextInputAction.next,
          onSubmitted: (_) => _quillFocusNode.requestFocus(),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.palette_outlined,
              color: _selectedColorValue != null
                  ? Color(_selectedColorValue!)
                  : Colors.black54,
              size: 24,
            ),
            onPressed: _showColorPicker,
            tooltip: 'Chọn màu',
            padding: const EdgeInsets.symmetric(horizontal: 12),
          ),
          if (widget.noteId != null)
            IconButton(
              icon: _isDeleting
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.red.shade400),
                      ),
                    )
                  : Icon(Icons.delete_outline, color: Colors.red.shade400, size: 24),
              onPressed: (_isSaving || _isDeleting) ? null : _deleteNote,
              tooltip: 'Xóa ghi chú',
              padding: const EdgeInsets.symmetric(horizontal: 12),
            ),
          IconButton(
            icon: _isSaving
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade600),
                    ),
                  )
                : Icon(Icons.check, color: Colors.blue.shade600, size: 24),
            onPressed: _isSaving ? null : _saveNote,
            tooltip: 'Lưu ghi chú',
            padding: const EdgeInsets.symmetric(horizontal: 12),
          ),
          const SizedBox(width: 4),
        ],
        toolbarHeight: 64,
      ),
      body: Container(
        color: Colors.white,
        child: SafeArea(
          child: Column(
            children: [
              Container(
                height: 1,
                color: Colors.grey[100],
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: QuillEditor(
                    controller: _quillController,
                    focusNode: _quillFocusNode,
                    scrollController: _scrollController,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  border: Border(
                    top: BorderSide(color: Colors.grey[200]!, width: 1),
                  ),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      // Text formatting group
                      _buildToolbarButton(
                        icon: Icons.format_bold,
                        tooltip: 'Đậm',
                        onPressed: () => _toggleFormat(Attribute.bold),
                      ),
                      _buildToolbarButton(
                        icon: Icons.format_italic,
                        tooltip: 'Nghiêng',
                        onPressed: () => _toggleFormat(Attribute.italic),
                      ),
                      _buildToolbarButton(
                        icon: Icons.format_underlined,
                        tooltip: 'Gạch dưới',
                        onPressed: () => _toggleFormat(Attribute.underline),
                      ),

                      // Separator
                      Container(
                        width: 1,
                        height: 32,
                        color: Colors.grey[300],
                        margin: const EdgeInsets.symmetric(horizontal: 12),
                      ),

                      // Headings
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.title, size: 22),
                        tooltip: 'Tiêu đề',
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        onSelected: (value) {
                          if (value == 'h1') {
                            _quillController.formatSelection(Attribute.h1);
                          } else if (value == 'h2') {
                            _quillController.formatSelection(Attribute.h2);
                          } else if (value == 'h3') {
                            _quillController.formatSelection(Attribute.h3);
                          } else if (value == 'normal') {
                            _quillController.formatSelection(Attribute.header);
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(value: 'h1', child: Text('Tiêu đề 1')),
                          const PopupMenuItem(value: 'h2', child: Text('Tiêu đề 2')),
                          const PopupMenuItem(value: 'h3', child: Text('Tiêu đề 3')),
                          const PopupMenuItem(value: 'normal', child: Text('Văn bản thường')),
                        ],
                      ),

                      // Lists
                      _buildToolbarButton(
                        icon: Icons.format_list_bulleted,
                        tooltip: 'Danh sách',
                        onPressed: () => _toggleFormat(Attribute.ul),
                      ),
                      _buildToolbarButton(
                        icon: Icons.format_list_numbered,
                        tooltip: 'Danh sách số',
                        onPressed: () => _toggleFormat(Attribute.ol),
                      ),
                      _buildToolbarButton(
                        icon: Icons.check_box,
                        tooltip: 'Ô đánh dấu',
                        onPressed: () => _toggleFormat(Attribute.unchecked),
                      ),

                      // Separator
                      Container(
                        width: 1,
                        height: 32,
                        color: Colors.grey[300],
                        margin: const EdgeInsets.symmetric(horizontal: 12),
                      ),

                      // Actions
                      _buildToolbarButton(
                        icon: Icons.undo,
                        tooltip: 'Hoàn tác',
                        onPressed: () => _quillController.undo(),
                      ),
                      _buildToolbarButton(
                        icon: Icons.redo,
                        tooltip: 'Làm lại',
                        onPressed: () => _quillController.redo(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToolbarButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onPressed,
  }) {
    return IconButton(
      icon: Icon(icon, size: 22, color: Colors.black87),
      onPressed: onPressed,
      tooltip: tooltip,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      constraints: const BoxConstraints(
        minWidth: 40,
        minHeight: 40,
      ),
    );
  }

  void _toggleFormat(Attribute attribute) {
    final isActive = _quillController.getSelectionStyle().attributes[attribute.key] != null;
    if (isActive) {
      _quillController.formatSelection(Attribute.clone(attribute, null));
    } else {
      _quillController.formatSelection(attribute);
    }
  }

  void _showColorPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Chọn màu ghi chú',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                if (_selectedColorValue != null)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _selectedColorValue = null;
                      });
                      Navigator.pop(context);
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.blue.shade600,
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    child: const Text('Xóa'),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _buildColorCircle(
                  null,
                  Colors.grey[300]!,
                  Icons.border_color_outlined,
                  _selectedColorValue == null,
                ),
                ..._availableColors.map((color) {
                  return _buildColorCircle(
                    color.value,
                    color,
                    null,
                    _selectedColorValue == color.value,
                  );
                }),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  /// Widget để chọn màu (dạng circle đơn giản)
  Widget _buildColorCircle(
    int? colorValue,
    Color color,
    IconData? icon,
    bool isSelected,
  ) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedColorValue = colorValue;
        });
        Navigator.pop(context);
      },
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? Colors.blue.shade600 : Colors.grey.shade300,
            width: isSelected ? 3 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.blue.shade600.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 4,
                  )
                ]
              : null,
        ),
        child: icon != null
            ? Icon(
                icon,
                color: Colors.black54,
                size: 24,
              )
            : isSelected
                ? Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 20,
                  )
                : null,
      ),
    );
  }
}