import 'package:flutter/material.dart';

import '../../../core/database/local_db.dart';

class CalendarViewModel extends ChangeNotifier {
  List<String> datesStringList = [];
  List<String> insulinStringList = [];
  List<String> carbohydrateStringList = [];

  void getDateList() async {
    datesStringList.clear();
    insulinStringList.clear();
    datesStringList = await CacheManeger.getList("dateList") ?? [];
    insulinStringList = await CacheManeger.getList("insulinList") ?? [];
    notifyListeners();
  }

  void clearDateList() async {
    await CacheManeger.remove("dateList");
    await CacheManeger.remove("insulinList");
    datesStringList.clear();
    insulinStringList.clear();
    notifyListeners();
  }
}
