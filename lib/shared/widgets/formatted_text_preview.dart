import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'dart:convert';
import '../../data/models/note_model.dart';

class FormattedTextPreview extends StatelessWidget {
  final NoteModel note;
  final bool isColored;
  final Color noteColor;
  final int maxLines;

  const FormattedTextPreview({
    super.key,
    required this.note,
    required this.isColored,
    required this.noteColor,
    this.maxLines = 3,
  });

  @override
  Widget build(BuildContext context) {
    if (note.content.isEmpty && (note.deltaContent == null || note.deltaContent!.isEmpty)) {
      return Text(
        'Không có nội dung',
        style: TextStyle(
          fontSize: 14,
          height: 1.3,
          color: isColored ? noteColor.withOpacity(0.8) : Colors.black87,
        ),
      );
    }

    if (note.deltaContent != null && note.deltaContent!.isNotEmpty) {
      try {
        final deltaJson = jsonDecode(note.deltaContent!);
        final document = Document.fromJson(deltaJson);

        return _buildFormattedPreview(document);
      } catch (e) {
        // Fallback to plain text if parsing fails
        return _buildPlainTextPreview();
      }
    } else {
      return _buildPlainTextPreview();
    }
  }

  Widget _buildFormattedPreview(Document document) {
    final List<Widget> previewWidgets = [];
    final delta = document.toDelta();
    final operations = delta.toList();
    
    int totalLines = 0;
    String currentLineText = '';
    Map<String, dynamic>? currentLineAttributes;
    List<TextSpan> currentLineSpans = [];

    for (final operation in operations) {
      if (totalLines >= maxLines) break;

      final data = operation.data;
      final attributes = operation.attributes;

      if (data is String) {
        // Check if this is a newline (line break)
        if (data.contains('\n')) {
          final lines = data.split('\n');
          
          for (int i = 0; i < lines.length; i++) {
            final lineText = lines[i];
            
            // Add text to current line
            if (lineText.isNotEmpty) {
              currentLineText += lineText;
              currentLineSpans.add(
                TextSpan(
                  text: lineText,
                  style: _getTextStyleFromAttributes(attributes ?? {}, isColored, noteColor),
                ),
              );
            }
            
            // If this is a newline character (not the last segment), finish current line
            if (i < lines.length - 1 || (i == 0 && data.endsWith('\n'))) {
              if (currentLineText.trim().isNotEmpty || previewWidgets.isEmpty) {
                final lineWidget = _buildLineWidget(
                  currentLineText,
                  currentLineSpans,
                  currentLineAttributes ?? attributes ?? {},
                  isColored,
                  noteColor,
                );
                
                if (lineWidget != null) {
                  previewWidgets.add(lineWidget);
                  totalLines++;
                  if (totalLines >= maxLines) break;
                }
              }
              
              // Reset for next line
              currentLineText = '';
              currentLineSpans = [];
              currentLineAttributes = null;
            }
          }
        } else {
          // Regular text, add to current line
          currentLineText += data;
          currentLineSpans.add(
            TextSpan(
              text: data,
              style: _getTextStyleFromAttributes(attributes ?? {}, isColored, noteColor),
            ),
          );
          currentLineAttributes = attributes;
        }
      } else if (attributes != null && (attributes.containsKey(Attribute.ul.key) || 
                                       attributes.containsKey(Attribute.ol.key) ||
                                       attributes.containsKey(Attribute.unchecked.key) ||
                                       attributes.containsKey(Attribute.checked.key))) {
        // This operation sets line-level attributes
        currentLineAttributes = attributes;
      }
    }

    // Add the last line if there's content
    if (currentLineText.trim().isNotEmpty && totalLines < maxLines) {
      final lineWidget = _buildLineWidget(
        currentLineText,
        currentLineSpans,
        currentLineAttributes ?? {},
        isColored,
        noteColor,
      );
      
      if (lineWidget != null) {
        previewWidgets.add(lineWidget);
        totalLines++;
      }
    }

    if (previewWidgets.isEmpty) {
      return _buildPlainTextPreview();
    }

    if (previewWidgets.length >= maxLines) {
      previewWidgets[previewWidgets.length - 1] = Row(
        children: [
          Expanded(
            child: previewWidgets[previewWidgets.length - 1],
          ),
          Text(
            '...',
            style: TextStyle(
              fontSize: 14,
              height: 1.3,
              color: isColored ? noteColor.withOpacity(0.6) : Colors.grey.shade500,
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: previewWidgets,
    );
  }

  Widget? _buildLineWidget(
    String lineText,
    List<TextSpan> textSpans,
    Map<String, dynamic> lineAttributes,
    bool isColored,
    Color noteColor,
  ) {
    if (lineText.trim().isEmpty) return null;

    // Check for list items
    if (lineAttributes.containsKey(Attribute.ul.key) || lineAttributes.containsKey(Attribute.ol.key)) {
      // Use bullet for both bullet and numbered lists in preview
      final bulletChar = '•';

      return RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$bulletChar ',
              style: TextStyle(
                fontSize: 14,
                height: 1.3,
                color: isColored ? noteColor.withOpacity(0.8) : Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
            ...textSpans,
          ],
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    } else if (lineAttributes.containsKey(Attribute.unchecked.key) || lineAttributes.containsKey(Attribute.checked.key)) {
      // Checkbox
      final isChecked = lineAttributes.containsKey(Attribute.checked.key);

      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 16,
            height: 16,
            margin: const EdgeInsets.only(right: 8, top: 2),
            decoration: BoxDecoration(
              border: Border.all(
                color: isColored ? noteColor.withOpacity(0.6) : Colors.grey.shade400,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(2),
              color: isChecked ? (isColored ? noteColor.withOpacity(0.2) : Colors.blue.shade50) : Colors.transparent,
            ),
            child: isChecked
                ? Icon(
                    Icons.check,
                    size: 12,
                    color: isColored ? noteColor : Colors.blue.shade600,
                  )
                : null,
          ),
          Expanded(
            child: RichText(
              text: TextSpan(children: textSpans.isNotEmpty ? textSpans : [
                TextSpan(
                  text: lineText,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.3,
                    color: isColored ? noteColor.withOpacity(0.8) : Colors.black87,
                  ),
                ),
              ]),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      );
    } else {
      // Regular formatted text or plain text
      return RichText(
        text: TextSpan(children: textSpans.isNotEmpty ? textSpans : [
          TextSpan(
            text: lineText,
            style: TextStyle(
              fontSize: 14,
              height: 1.3,
              color: isColored ? noteColor.withOpacity(0.8) : Colors.black87,
            ),
          ),
        ]),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    }
  }

  Widget _buildPlainTextPreview() {
    final lines = note.content.split('\n');
    final previewText = lines.length > maxLines
        ? lines.take(maxLines).join('\n') + '...'
        : note.content;

    return Text(
      previewText,
      style: TextStyle(
        fontSize: 14,
        height: 1.3,
        color: isColored ? noteColor.withOpacity(0.8) : Colors.black87,
      ),
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
    );
  }

  TextStyle _getTextStyleFromAttributes(Map<String, dynamic>? attributes, bool isColored, Color noteColor) {
    FontWeight fontWeight = FontWeight.normal;
    FontStyle fontStyle = FontStyle.normal;
    TextDecoration textDecoration = TextDecoration.none;

    if (attributes != null) {
      if (attributes.containsKey(Attribute.bold.key)) {
        fontWeight = FontWeight.bold;
      }
      if (attributes.containsKey(Attribute.italic.key)) {
        fontStyle = FontStyle.italic;
      }
      if (attributes.containsKey(Attribute.underline.key)) {
        textDecoration = TextDecoration.underline;
      }
    }

    return TextStyle(
      fontSize: 14,
      height: 1.3,
      color: isColored ? noteColor.withOpacity(0.8) : Colors.black87,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      decoration: textDecoration,
    );
  }
}
