import 'package:flutter/material.dart';

import 'NoteCards.dart';
import '../../utils/date_utils.dart' as CustomDateUtils;

class NotesOnDate extends StatelessWidget {
  final DateTime date;
  final List<DateTime>? notesDates;
  final int? refreshCounter;
  final Future<void> Function()? onRefresh;

  const NotesOnDate({
    super.key,
    required this.date,
    this.notesDates,
    this.refreshCounter,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final allWeekDates = CustomDateUtils.DateUtils.getDaysInWeek(date);

    List<DateTime> weekDatesWithNotes = [];
    if (notesDates != null && notesDates!.isNotEmpty) {
      weekDatesWithNotes = allWeekDates.where((weekDate) {
        return notesDates!.any((noteDate) {
          return CustomDateUtils.DateUtils.isSameDate(weekDate, noteDate);
        });
      }).toList();
    }
    
    return RefreshIndicator(
      onRefresh: () async {
        if (onRefresh != null) {
          await onRefresh!();
        }
        await Future.delayed(const Duration(milliseconds: 300));
      },
      child: Container(
        padding: EdgeInsets.all(10),
        child: weekDatesWithNotes.isEmpty
            ? SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.4,
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
                        const SizedBox(height: 8),
                        Text(
                          'Pull down to refresh',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
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
                                minHeight: 100,
                              ),
                              child: Notecards(
                                key: ValueKey('notecards_${date.toIso8601String()}_${refreshCounter ?? 0}'),
                                selectedDate: date,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
      ),
    );
  }
}