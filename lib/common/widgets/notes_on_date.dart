import 'package:flutter/material.dart';

import 'NoteCards.dart';
import '../utils/date_utils.dart' as CustomDateUtils;

class NotesOnDate extends StatelessWidget {
  final DateTime date;

  const NotesOnDate({
    super.key, 
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    final weekDatesWithNotes = CustomDateUtils.DateUtils.getWeekDatesWithNotes(date);
    
    if (weekDatesWithNotes.isEmpty) {
      return Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.note_outlined,
                size: 64,
                color: Colors.grey.withOpacity(0.5),
              ),
              const SizedBox(height: 16),
              Text(
                "No notes for this week",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.withOpacity(0.7),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      padding: EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Column(
          children: weekDatesWithNotes.map((date) {
            return Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 80,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          CustomDateUtils.DateUtils.getDayName(date.weekday),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '${date.day}',
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      constraints: BoxConstraints(
                        minHeight: 100, // Chiều cao tối thiểu
                        maxHeight: 300, // Chiều cao tối đa
                      ),
                      child: Notecards(selectedDate: date),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}