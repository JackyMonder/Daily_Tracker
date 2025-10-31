/// Models cho HorizontalWeekView
class WeekViewConfig {
  final DateTime? selectedDate;
  final Function(DateTime)? onDateSelected;
  final List<DateTime>? notesDates;

  const WeekViewConfig({
    this.selectedDate,
    this.onDateSelected,
    this.notesDates,
  });
}

class WeekViewState {
  final DateTime selectedDate;
  final DateTime currentDaySelected;
  final int currentPage;
  final List<DateTime> daysInWeek;

  const WeekViewState({
    required this.selectedDate,
    required this.currentDaySelected,
    required this.currentPage,
    required this.daysInWeek,
  });

  WeekViewState copyWith({
    DateTime? selectedDate,
    DateTime? currentDaySelected,
    int? currentPage,
    List<DateTime>? daysInWeek,
  }) {
    return WeekViewState(
      selectedDate: selectedDate ?? this.selectedDate,
      currentDaySelected: currentDaySelected ?? this.currentDaySelected,
      currentPage: currentPage ?? this.currentPage,
      daysInWeek: daysInWeek ?? this.daysInWeek,
    );
  }
}
