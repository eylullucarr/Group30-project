import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:insulin_calculate/core/database/local_db.dart';
import 'package:insulin_calculate/product/calculate/model/food_model.dart';
import '../../calendar/model/calendar_model.dart';

class CalculateViewModel extends ChangeNotifier {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>>? dataList; // firestore verileri
  bool isInclude = true; // seçili date listte var mı
  DateTime selectedDate = DateTime.now(); // seçili tarih
  int selectedDateIndex = 0; // seçili tarihin indexi
  bool createdDefaultData = false; // ilk açılışta veriler oluşturuldu mu
  bool isLoading = false; // veriler yükleniyor mu
  List<FoodModel> foods = []; // besinler
  List<DateModel> dateList = []; // tarihler
  List<String> datesStringList = []; // tarihlerin string hali
  List<String> insulinStringList = []; // insülin miktarlarının string hali

  Future getFoodsList() async {
    //bu  fonksiyon firebaseden verileri çekiyor
    await Future.delayed(Duration(milliseconds: 500));
    QuerySnapshot querySnapshot = await firestore.collection('foods').get();
    List<QueryDocumentSnapshot> documentList = querySnapshot.docs;
    dataList = await querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();

    if (foods.isEmpty) {
      for (var i = 0; i < dataList!.length; i++) {
        //bu döngüde çekilen verileri food modeline dönüştürüyor
        foods.add(FoodModel(
            name: dataList![i]["name"],
            carbohydrateAmount: dataList![i]["carbohydrate"],
            count: 0));
      }
    }

    if (dateList.isEmpty) {
      createDefaultData(); //ilk açılışta verileri oluşturuyor
    }

    notifyListeners();

    return dataList;
  }

//Tarih İşlemleri
  void changeSelectedDate(DateTime newTime) {
    // datepicker ile seçilen tarihi değiştiriyor
    selectedDate = newTime;
    notifyListeners();
  }

  void clearData() {
    //bu fonksiyon verileri temizliyor
    dateList.clear();
    datesStringList.clear();
    insulinStringList.clear();
    notifyListeners();
  }

  void isIncludeSelectedDate() {
    //bu fonksiyon seçili tarihin listede olup olmadığını kontrol ediyor ve seçili tarihin indexini buluyor
    for (int i = 0; i < dateList.length; i++) {
      if (dateList[i].date.month == selectedDate.month &&
          dateList[i].date.day == selectedDate.day &&
          dateList[i].date.year == selectedDate.year) {
        isInclude = true; // selectedDate listede var mı kontrol ediyor
        selectedDateIndex = getIndexForDate();

        notifyListeners();
        return;
      }
    }
    isInclude = false;

    notifyListeners();
  }

  void saveLocalDb() async {
    //bu fonksiyon verileri local db ye kaydediyor
    datesStringList.clear();
    insulinStringList.clear();

    toStringList();
    await CacheManeger.saveList("dateList", datesStringList);
    await CacheManeger.saveList("insulinList", insulinStringList);
    notifyListeners();
  }

  void createDefaultData() async {
    //bu fonksiyon ilk açılışta verileri oluşturuyor (o an ki tarihe ait veriler DateTime.now() ile alınıyor)
    createdDefaultData = false;

    dateList.add(DateModel(
      date: DateTime.now(),
      insulinCount: 0,
      carbohydrateAmount: 0,
      foods: foods,
    ));

    saveLocalDb(); // verileri local db ye kaydediyor
    createdDefaultData = true;
    notifyListeners();
  }

  int getIndexForDate() {
    //bu fonksiyon seçili tarihin listedeki indexini buluyor
    for (int i = 0; i < dateList.length; i++) {
      if (dateList[i].date.isAtSameMomentAs(selectedDate)) {
        return i;
      }
    }
    return 0;
  }

  void addCarbohydrate(int foodIndex) {
    // bu fonksiyon seçilen besinin karbonhidrat miktarını ve insülin miktarını hesaplıyor(ekleme)
    dateList[selectedDateIndex].foods[foodIndex].count +=
        1; // besin sayısı arttırılıyor

    dateList[selectedDateIndex].carbohydrateAmount += foods[foodIndex]
        .carbohydrateAmount; // Karbonhidrat miktarı hesaplanıyor

    dateList[selectedDateIndex].insulinCount =
        (dateList[selectedDateIndex].carbohydrateAmount / 15)
            .round(); // İnsülin miktarı hesaplanıyor

    saveLocalDb(); // verileri local db ye kaydediyor

    notifyListeners();
  }

  void removeCarbohydrate(int foodIndex) {
    // bu fonksiyon seçilen besinin karbonhidrat miktarını ve insülin miktarını hesaplıyor(çıkarma)
    if (dateList[selectedDateIndex].foods[foodIndex].count > 0 && isInclude) {
      print("dahil");
      dateList[selectedDateIndex].carbohydrateAmount -= foods[foodIndex]
          .carbohydrateAmount; // Karbonhidrat miktarı hesaplanıyor

      dateList[selectedDateIndex].foods[foodIndex].count -=
          1; // besin sayısı azaltılıyor
    }

    dateList[selectedDateIndex].insulinCount =
        (dateList[selectedDateIndex].carbohydrateAmount / 15)
            .round(); // İnsülin miktarı hesaplanıyor

    saveLocalDb(); // verileri local db ye kaydediyor

    notifyListeners();
  }

  void addDateToList() async {
    //bu fonksiyon seçili tarihi listeye ekliyor
    foods.clear();
    List<FoodModel> _foods = foods;

    dateList.add(DateModel(
        date: selectedDate,
        insulinCount: 0,
        carbohydrateAmount: 0,
        foods: _foods));

    saveLocalDb(); // verileri local db ye kaydediyor

    isInclude = true;

    notifyListeners();
  }

  void toStringList() {
    for (var i = 0; i < dateList.length; i++) {
      datesStringList.add(
          "${dateList[i].date.day} ${months[dateList[i].date.month]} ${dateList[i].date.year}");

      insulinStringList.add("${dateList[i].insulinCount}");
      notifyListeners();
    }
  }

  Map<String, int> foodsData(List<Map<String, dynamic>> _dataList) {
    //bu fonksiyon besinlerin isimlerini ve sayılarını bir map olarak döndürüyor
    Map<String, int> foods = {};

    for (var i = 0; i < _dataList.length; i++) {
      foods["${_dataList[i]["name"]}"] = 0;
    }
    notifyListeners();
    return foods;
  }

  Map<int, String> months = {
    1: "Ocak",
    2: "Şubat",
    3: "Mart",
    4: "Nisan",
    5: "Mayıs",
    6: "Haziran",
    7: "Temmuz",
    8: "Ağustos",
    9: "Eylül",
    10: "Ekim",
    11: "Kasım",
    12: "Aralık"
  };
}
