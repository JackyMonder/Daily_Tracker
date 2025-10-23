import 'package:flutter/material.dart';
import '../utils/date_utils.dart' as CustomDateUtils;

/// Widget hiển thị một ngày trong tuần
class DayWidget extends StatelessWidget {
  final DateTime day;
  final bool isSelected;
  final VoidCallback onTap;

  const DayWidget({
    super.key,
    required this.day,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              CustomDateUtils.DateUtils.getDayName(day.weekday),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
            SizedBox(height: 4),
            Text(
              '${day.day}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
