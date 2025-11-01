import 'package:flutter/material.dart';
import '../../data/models/note_model.dart';
import '../../data/repositories/note_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NoteEditorScreen extends StatefulWidget {
  final String? noteId; // ID của note đang edit (null nếu là note mới)
  final String? initialTitle;
  final String? initialContent;
  final int? initialColorValue;
  final DateTime? selectedDate; // Ngày được chọn để tạo note

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
  late final TextEditingController _contentController;
  late final FocusNode _titleFocusNode;
  late final FocusNode _contentFocusNode;

  final NoteRepository _noteRepository = NoteRepository();
  bool _isSaving = false;
  bool _isDeleting = false;
  int? _selectedColorValue;

  // Màu sắc có sẵn để chọn
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
    _contentController =
        TextEditingController(text: widget.initialContent ?? '');
    _titleFocusNode = FocusNode();
    _contentFocusNode = FocusNode();
    _selectedColorValue = widget.initialColorValue;

    // Tự động focus vào title nếu là note mới
    if (widget.noteId == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _titleFocusNode.requestFocus();
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _titleFocusNode.dispose();
    _contentFocusNode.dispose();
    super.dispose();
  }

  /// Lưu note vào Firebase
  Future<void> _saveNote() async {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    // Validate
    if (title.isEmpty && content.isEmpty) {
      // Không lưu note trống
      Navigator.of(context).pop();
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      // Lấy userId từ Firebase Auth (nếu có)
      final userId = FirebaseAuth.instance.currentUser?.uid;

      if (widget.noteId != null) {
        // Update note hiện có
        final existingNote = await _noteRepository.getNoteById(widget.noteId!);
        if (existingNote != null) {
          final updatedNote = existingNote.copyWith(
            title: title.isEmpty ? 'Untitled' : title,
            content: content,
            colorValue: _selectedColorValue,
            userId: userId,
          );
          await _noteRepository.updateNote(widget.noteId!, updatedNote);
        }
      } else {
        // Tạo note mới với ngày được chọn (nếu có)
        final newNote = NoteModel.create(
          title: title.isEmpty ? 'Untitled' : title,
          content: content,
          userId: userId,
          colorValue: _selectedColorValue,
          createdAt: widget.selectedDate, 
        );
        await _noteRepository.createNote(newNote);
      }

      if (mounted) {
        // Hiển thị thông báo thành công
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Note saved successfully'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
        Navigator.of(context).pop(true); // Trả về true để parent refresh
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

  /// Xóa note
  Future<void> _deleteNote() async {
    if (widget.noteId == null) {
      // Nếu là note mới, chỉ cần đóng
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Nếu có màu được chọn, dùng màu đó làm background
    final backgroundColor = _selectedColorValue != null
        ? Color(_selectedColorValue!).withOpacity(0.05)
        : colorScheme.surface;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        backgroundColor: backgroundColor,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                (_selectedColorValue != null
                        ? Color(_selectedColorValue!)
                        : colorScheme.primaryContainer)
                    .withOpacity(0.1),
                colorScheme.secondaryContainer.withOpacity(0.05),
              ],
            ),
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: colorScheme.onSurface,
          ),
          style: IconButton.styleFrom(
            backgroundColor: backgroundColor.withOpacity(0.8),
            foregroundColor: colorScheme.onSurface,
          ),
        ),
        title: TextField(
          controller: _titleController,
          focusNode: _titleFocusNode,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: _selectedColorValue != null
                ? Color(_selectedColorValue!)
                : colorScheme.onSurface,
          ),
          decoration: InputDecoration(
            hintText: 'Note title...',
            hintStyle: TextStyle(
              color: colorScheme.onSurface.withOpacity(0.6),
              fontWeight: FontWeight.w400,
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.zero,
          ),
          textInputAction: TextInputAction.next,
          onSubmitted: (_) => _contentFocusNode.requestFocus(),
        ),
        actions: [
          // Delete button (chỉ hiện khi đang edit)
          if (widget.noteId != null)
            IconButton(
              onPressed: (_isSaving || _isDeleting) ? null : _deleteNote,
              icon: _isDeleting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.red,
                      ),
                    )
                  : Icon(
                      Icons.delete_outline_rounded,
                      color: Colors.red.withOpacity(0.7),
                    ),
              tooltip: 'Delete Note',
            ),
          // Save button
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: IconButton(
              onPressed: _isSaving ? null : _saveNote,
              icon: _isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Icon(
                      Icons.check_rounded,
                      color: colorScheme.onPrimary,
                    ),
              style: IconButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(12),
              ),
              tooltip: 'Save Note',
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              backgroundColor,
              colorScheme.surfaceContainerLowest,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date and time info
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        size: 16,
                        color: colorScheme.onSurface.withOpacity(0.7),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _getCurrentDateTime(),
                        style: TextStyle(
                          fontSize: 12,
                          color: colorScheme.onSurface.withOpacity(0.7),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Content text field
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: _contentFocusNode.hasFocus
                            ? (_selectedColorValue != null
                                    ? Color(_selectedColorValue!)
                                    : colorScheme.primary)
                                .withOpacity(0.3)
                            : colorScheme.outline.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: TextField(
                      controller: _contentController,
                      focusNode: _contentFocusNode,
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        color: colorScheme.onSurface,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Start writing your thoughts...',
                        hintStyle: TextStyle(
                          color: colorScheme.onSurface.withOpacity(0.5),
                          fontSize: 16,
                          height: 1.5,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(20),
                      ),
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      expands: true,
                      textAlignVertical: TextAlignVertical.top,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Color picker
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color:
                        colorScheme.surfaceContainerHighest.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          children: [
                            Icon(
                              Icons.palette_outlined,
                              size: 18,
                              color: colorScheme.onSurface.withOpacity(0.6),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Color',
                              style: TextStyle(
                                fontSize: 12,
                                color: colorScheme.onSurface.withOpacity(0.6),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Spacer(),
                            if (_selectedColorValue != null)
                              TextButton.icon(
                                onPressed: () {
                                  setState(() {
                                    _selectedColorValue = null;
                                  });
                                },
                                icon: const Icon(Icons.close, size: 16),
                                label: const Text('Clear'),
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  minimumSize: Size.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          children: [
                            // No color option
                            _buildColorOption(
                              null,
                              colorScheme.onSurface.withOpacity(0.2),
                              Icons.border_color_outlined,
                              _selectedColorValue == null,
                            ),
                            const SizedBox(width: 8),
                            // Color options
                            ..._availableColors.map((color) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: _buildColorOption(
                                  color.value,
                                  color,
                                  null,
                                  _selectedColorValue == color.value,
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                // Bottom action bar
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.edit_note_rounded,
                        size: 18,
                        color: colorScheme.onSurface.withOpacity(0.6),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${_contentController.text.length} characters',
                        style: TextStyle(
                          fontSize: 12,
                          color: colorScheme.onSurface.withOpacity(0.6),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Widget để chọn màu
  Widget _buildColorOption(
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
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.transparent,
            width: 3,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Theme.of(context)
                        .colorScheme
                        .primary
                        .withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: icon != null
            ? Icon(
                icon,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                size: 20,
              )
            : null,
      ),
    );
  }

  String _getCurrentDateTime() {
    final now = DateTime.now();
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
    return '${now.day} ${months[now.month - 1]} ${now.year} • ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }
}
