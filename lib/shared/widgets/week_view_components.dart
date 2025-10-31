import 'package:flutter/material.dart';
import '../../utils/date_utils.dart' as CustomDateUtils;
import 'day_widget.dart';

/// Widget hiển thị header với tháng và năm
class WeekViewHeader extends StatelessWidget {
  final DateTime currentDate;

  const WeekViewHeader({
    super.key,
    required this.currentDate,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      '${CustomDateUtils.DateUtils.getMonthName(currentDate.month)}, ${currentDate.year}',
      textAlign: TextAlign.left,
      style: TextStyle(
        fontSize: 50,
        fontWeight: FontWeight.bold,
        color: Colors.black
      ),
    );
  }
}

/// Widget hiển thị một tuần với 7 ngày
class WeekViewPage extends StatelessWidget {
  final List<DateTime> daysInWeek;
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;

  const WeekViewPage({
    super.key,
    required this.daysInWeek,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: daysInWeek.map((day) => DayWidget(
          day: day,
          isSelected: CustomDateUtils.DateUtils.isSameDate(day, selectedDate),
          onTap: () => onDateSelected(day),
        )).toList(),
      ),
    );
  }
}
