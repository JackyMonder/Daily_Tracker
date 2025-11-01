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
    final operations = document.toDelta().toList();
    final List<Widget> previewWidgets = [];
    int totalLines = 0;

    for (final operation in operations) {
      if (totalLines >= maxLines) break;

      final data = operation.data;
      final attributes = operation.attributes;

      if (data is String) {
        final lines = data.split('\n');
        for (final line in lines) {
          if (totalLines >= maxLines) break;

          if (line.trim().isEmpty && previewWidgets.isNotEmpty) continue;

          Widget lineWidget;

          // Check for list items
          if (attributes != null) {
            if (attributes.containsKey(Attribute.ul.key) || attributes.containsKey(Attribute.ol.key)) {
              // Bullet or numbered list
              final isBullet = attributes.containsKey(Attribute.ul.key);
              final bulletChar = isBullet ? '•' : '${previewWidgets.where((w) => w is RichText).length + 1}.';

              lineWidget = RichText(
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
                    TextSpan(
                      text: line.trim(),
                      style: _getTextStyle(attributes),
                    ),
                  ],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              );
            } else if (attributes.containsKey(Attribute.unchecked.key) || attributes.containsKey(Attribute.checked.key)) {
              // Checkbox
              final isChecked = attributes.containsKey(Attribute.checked.key);

              lineWidget = Row(
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
                    child: Text(
                      line.trim(),
                      style: _getTextStyle(attributes),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              );
            } else {
              // Regular formatted text
              lineWidget = Text(
                line.trim(),
                style: _getTextStyle(attributes),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              );
            }
          } else {
            // Plain text
            lineWidget = Text(
              line.trim(),
              style: TextStyle(
                fontSize: 14,
                height: 1.3,
                color: isColored ? noteColor.withOpacity(0.8) : Colors.black87,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            );
          }

          previewWidgets.add(lineWidget);
          totalLines++;

          if (totalLines >= maxLines) break;
        }
      }
    }

    if (previewWidgets.length > maxLines) {
      previewWidgets.removeLast();
      previewWidgets.add(
        Text(
          '...',
          style: TextStyle(
            fontSize: 14,
            height: 1.3,
            color: isColored ? noteColor.withOpacity(0.6) : Colors.grey.shade500,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: previewWidgets,
    );
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

  TextStyle _getTextStyle(Map<String, dynamic>? attributes) {
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
