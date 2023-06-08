import 'package:hive/hive.dart';
import 'package:insulin_calculate/product/calculate/model/food_model.dart';

@HiveType(typeId: 1)
class DateModel extends HiveObject {
  @HiveField(0)
  late List<FoodModel> foods;

  @HiveField(1)
  final DateTime date;

  @HiveField(2)
  int carbohydrateAmount;

  @HiveField(3)
  int insulinCount;

  DateModel(
      {required this.date,
      required this.insulinCount,
      required this.foods,
      required this.carbohydrateAmount});
}
