import 'package:flutter/material.dart';
import 'package:todo_app/models/filter_model.dart';

class FilterListViewModel extends ChangeNotifier {
  FilterModel? _filterModel;
  int count = 0;
  FilterModel? get filterModel => _filterModel;
  Future<void> getCurrentFilters() async {
    count = 0;
    final filterDetails = await FilterModel.getFilters();
    _filterModel = filterDetails;
    if (_filterModel?.priority != null) {
      count++;
    }
    if (_filterModel?.category != null) {
      count++;
    }
    if (_filterModel?.isAllTodos != false) {
      count++;
    }
    notifyListeners();
  }
}
