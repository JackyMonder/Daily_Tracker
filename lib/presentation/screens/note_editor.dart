import 'package:flutter/material.dart';

class NoteEditorScreen extends StatefulWidget {
  final String? initialTitle;
  final String? initialContent;

  const NoteEditorScreen({super.key, this.initialTitle, this.initialContent});

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  late final FocusNode _titleFocusNode;
  late final FocusNode _contentFocusNode;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle ?? '');
    _contentController = TextEditingController(text: widget.initialContent ?? '');
    _titleFocusNode = FocusNode();
    _contentFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _titleFocusNode.dispose();
    _contentFocusNode.dispose();
    super.dispose();
  }

  void _saveAndPop() {
    Navigator.of(context).pop({
      'title': _titleController.text.trim(),
      'content': _contentController.text.trim(),
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        backgroundColor: colorScheme.surface,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                colorScheme.primaryContainer.withOpacity(0.1),
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
            backgroundColor: colorScheme.surface.withOpacity(0.8),
            foregroundColor: colorScheme.onSurface,
          ),
        ),
        title: TextField(
          controller: _titleController,
          focusNode: _titleFocusNode,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
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
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: IconButton(
              onPressed: _saveAndPop,
              icon: Icon(
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
              colorScheme.surface,
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
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                            ? colorScheme.primary.withOpacity(0.3)
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
                // Bottom action bar
                Row(
                  children: [
                    Expanded(
                      child: Container(
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
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getCurrentDateTime() {
    final now = DateTime.now();
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${now.day} ${months[now.month - 1]} ${now.year} • ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }
}


