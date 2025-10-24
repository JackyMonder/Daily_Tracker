/// Utility functions cho date manipulation trong WeekView
import '../widgets/NoteCards.dart';

class DateUtils {
  /// Lấy ngày đầu tuần (thứ 2)
  static DateTime getWeekStart(DateTime date) {
    return date.subtract(Duration(days: date.weekday - 1));
  }

  /// Lấy danh sách 7 ngày trong tuần
  static List<DateTime> getDaysInWeek(DateTime date) {
    DateTime weekStart = getWeekStart(date);
    return List.generate(7, (index) => weekStart.add(Duration(days: index)));
  }

  /// Kiểm tra xem có phải ngày hiện tại không
  static DateTime getDateSelected(DateTime date) {
    DateTime currentDate = DateTime.now();
    if (date.month == currentDate.month && date.day == currentDate.day) {
      return DateTime(currentDate.year, currentDate.month, currentDate.day);
    } else {
      return DateTime(date.year, date.month, date.day);
    }   
  }

  /// Kiểm tra xem hai ngày có giống nhau không (chỉ so sánh ngày/tháng/năm)
  static bool isSameDate(DateTime date1, DateTime date2) {
    return date1.day == date2.day &&
           date1.month == date2.month &&
           date1.year == date2.year;
  }

  /// Lấy danh sách các ngày trong tuần có notes
  static List<DateTime> getWeekDatesWithNotes(DateTime selectedDate) {
    final List<DateTime> weekDates = [];
    final DateTime startOfWeek = selectedDate.subtract(Duration(days: selectedDate.weekday - 1));
    
    for (int i = 0; i < 7; i++) {
      final DateTime date = startOfWeek.add(Duration(days: i));
      final notecards = Notecards(selectedDate: date);
      final filteredData = notecards.filteredCardData;
      
      if (filteredData.isNotEmpty) {
        weekDates.add(date);
      }
    }
    
    return weekDates;
  }

  /// Lấy tên ngày trong tuần
  static String getDayName(int day) {
    const dayNames = [
      'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'
    ];
    return dayNames[day - 1];
  }

  /// Lấy tên tháng
  static String getMonthName(int month) {
    const monthNames = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return monthNames[month - 1];
  }
}
