class FoodModel {
  final String name;
  final int carbohydrateAmount;
  int count;

  FoodModel({
    required this.name,
    required this.carbohydrateAmount,
    this.count = 0,
  });
}
