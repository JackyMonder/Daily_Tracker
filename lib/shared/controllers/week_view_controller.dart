import 'package:flutter/material.dart';
import '../models/week_view_models.dart';
import '../../utils/date_utils.dart' as CustomDateUtils;

/// Controller quản lý state và logic cho WeekView
class WeekViewController {
  late PageController _pageController;
  late WeekViewState _state;
  final WeekViewConfig config;

  WeekViewController({required this.config}) {
    _initializeState();
  }

  void _initializeState() {
    // Luôn focus vào ngày hiện tại
    final now = DateTime.now();
    final selectedDate = now;
    final currentDaySelected = now;
    final currentPage = 500; // Bắt đầu từ page 500 (giữa)
    
    _state = WeekViewState(
      selectedDate: selectedDate,
      currentDaySelected: currentDaySelected,
      currentPage: currentPage,
      daysInWeek: CustomDateUtils.DateUtils.getDaysInWeek(currentDaySelected),
    );

    _pageController = PageController(initialPage: currentPage);
  }

  PageController get pageController => _pageController;
  WeekViewState get state => _state;

  void dispose() {
    _pageController.dispose();
  }

  void onDateSelected(DateTime date, Function(WeekViewState) onStateChanged) {
    _state = _state.copyWith(
      currentDaySelected: date,
      daysInWeek: CustomDateUtils.DateUtils.getDaysInWeek(date),
    );
    onStateChanged(_state);
    config.onDateSelected?.call(_state.currentDaySelected);
  }

  void onPageChanged(int page, Function(WeekViewState) onStateChanged) {
    // Tính toán tuần mới dựa trên page index
    int weekOffset = page - 500; // Offset từ tuần hiện tại
    
    // Lấy tuần hiện tại và tính toán tuần mới
    DateTime currentWeekStart = CustomDateUtils.DateUtils.getWeekStart(DateTime.now());
    DateTime newWeekStart = currentWeekStart.add(Duration(days: weekOffset * 7));
    
    // Luôn focus vào ngày hiện tại trong tuần đó
    final now = DateTime.now();
    final newWeekDays = CustomDateUtils.DateUtils.getDaysInWeek(newWeekStart);
    // Kiểm tra xem ngày hiện tại có trong tuần này không
    final todayInWeek = newWeekDays.firstWhere(
      (day) => CustomDateUtils.DateUtils.isSameDate(day, now),
      orElse: () => newWeekStart, // Nếu không có, chọn ngày đầu tuần
    );
    
    _state = _state.copyWith(
      currentPage: page,
      currentDaySelected: todayInWeek, // Focus vào ngày hiện tại
      daysInWeek: newWeekDays,
    );
    
    onStateChanged(_state);
    config.onDateSelected?.call(_state.currentDaySelected);
  }
}
