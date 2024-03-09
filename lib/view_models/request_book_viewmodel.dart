import 'package:flutter/material.dart';

class RequestBookViewModel with ChangeNotifier {
  DateTime? _selectedStartDate;
  DateTime? get selectedStartDate => _selectedStartDate;
  DateTime? _selectedEndDate;
  DateTime? get selectedEndDate => _selectedEndDate;
  bool _isDateRangeSelected = false;
  bool get isDateRangeSelected => _isDateRangeSelected;

  DateTime initialStartDate = DateTime.now();
  DateTime initialEndDate = DateTime.now().add(const Duration(days: 5));

  FocusNode startDateFocus = FocusNode();
  FocusNode endDateFocus = FocusNode();

  /// Combine [pickedDateRange] with current [DateTime]
  DateTime combineDateAndTime(DateTime date) {
    DateTime time = DateTime.now();
    return DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
      time.second,
    );
  }

  /// Pick the date range for duration of book exchange
  Future<bool> pickDateRange(BuildContext context) async {
    final DateTimeRange? pickedDateRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: DateTimeRange(
        start: selectedStartDate ?? initialStartDate,
        end: selectedEndDate ?? initialEndDate,
      ),
    );

    if (pickedDateRange != null) {
      _selectedStartDate = combineDateAndTime(pickedDateRange.start);
      _selectedEndDate = combineDateAndTime(pickedDateRange.end);
      _isDateRangeSelected = true;
      notifyListeners();
      return true;
    } else {
      _isDateRangeSelected = false;
      clearSelectedDates();
      notifyListeners();
      return false;
    }
  }

  void clearSelectedDates() {
    _selectedStartDate = initialStartDate;
    _selectedEndDate = initialEndDate;
    notifyListeners();
  }
}
