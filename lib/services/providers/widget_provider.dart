import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class WidgetProvider with ChangeNotifier {
  int? _expandedField = -1;
  
  int get expandedField => _expandedField ?? -1;
  
  void toggleExpand(int index) {
      _expandedField = _expandedField == index ? null : index;
      notifyListeners();
  }

  bool _isFilledUsername = false;
  bool _isFilledEmail = false;
  bool _isFilledPassword = false;

  bool get isFilledUsername => _isFilledUsername;
  bool get isFilledEmail => _isFilledEmail;
  bool get isFilledPassword => _isFilledPassword;

  void setFilledStatus({required int index, required bool value}) {
    switch (index) {
      case 0:
        _isFilledUsername = value;
        break;
      case 1:
        _isFilledEmail = value;
        break;
      case 2:
        _isFilledPassword = value;
        break;
    }
    notifyListeners();
  }

  // TextEditingController _selectedDate = new TextEditingController();
  // TextEditingController get selectedDate => _selectedDate;

  void pickDate(BuildContext context, TextEditingController _selectedDate) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2025),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      String formattedDate = DateFormat("yyyy-MM-dd").format(pickedDate);
      _selectedDate.text = formattedDate;
      notifyListeners();
    }
  }
}