/** NOTE: HorizontalWeekView currently uses a fixed number of pages (itemCount: 1000).
 Future update: Hybrid Approach
 - Combine date-based calculation with dynamic loading
 - Use DateTime as the basis instead of page number
 - Each page is calculated from the base date
 - Pages are auto loaded/unloaded as needed
 */

import 'package:flutter/material.dart';
import '../models/week_view_models.dart';
import '../controllers/week_view_controller.dart';
import 'week_view_components.dart';

class HorizontalWeekView extends StatefulWidget {
  final DateTime? selectedDate;
  final Function(DateTime)? onDateSelected;
  final List<DateTime>? notesDates;

  const HorizontalWeekView({
    super.key,
    this.selectedDate,
    this.onDateSelected,
    this.notesDates,
  });

  @override
  State<HorizontalWeekView> createState() => _HorizontalWeekViewState();
}

class _HorizontalWeekViewState extends State<HorizontalWeekView> 
    with TickerProviderStateMixin {
  late WeekViewController _controller;
  late WeekViewState _state;

  @override
  void initState() {
    super.initState();
    _controller = WeekViewController(
      config: WeekViewConfig(
        selectedDate: widget.selectedDate,
        onDateSelected: widget.onDateSelected,
        notesDates: widget.notesDates,
      ),
    );
    _state = _controller.state;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onStateChanged(WeekViewState newState) {
    setState(() {
      _state = newState;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WeekViewHeader(currentDate: _state.currentDaySelected),
        
        SizedBox(height: 16),
        
        SizedBox(
          height: 100, // Đặt chiều cao cố định cho PageView
          child: PageView.builder(
            controller: _controller.pageController,
            onPageChanged: (page) => _controller.onPageChanged(page, _onStateChanged),
            itemCount: 1000, // Đặt số lượng page lớn để có thể swipe nhiều
            itemBuilder: (context, index) {
              return WeekViewPage(
                daysInWeek: _state.daysInWeek,
                selectedDate: _state.currentDaySelected,
                onDateSelected: (date) => _controller.onDateSelected(date, _onStateChanged),
              );
            },
          ),
        ),
      ],
    );
  }
}