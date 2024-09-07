import 'package:hive_flutter/hive_flutter.dart';

part 'meal_entity.g.dart';

@HiveType(typeId: 6)
class MealEntity {
  @HiveField(0)
  String id;

  @HiveField(1)
  String fats;

  @HiveField(2)
  String name;

  @HiveField(3)
  String time;

  @HiveField(4)
  String image;

  @HiveField(5)
  List<String> weeks;

  @HiveField(6)
  String carbos;

  @HiveField(7)
  String fibers;

  @HiveField(8)
  double? rating;

  @HiveField(9)
  String country;

  @HiveField(10)
  int? ratings;

  @HiveField(11)
  String calories;

  @HiveField(12)
  String headline;

  @HiveField(13)
  List<String> keywords;

  @HiveField(14)
  List<String> products;

  @HiveField(15)
  String proteins;

  @HiveField(16)
  int favorites;

  @HiveField(17)
  int difficulty;

  @HiveField(18)
  String description;

  @HiveField(19)
  bool highlighted;

  @HiveField(20)
  List<String> ingredients;

  @HiveField(21)
  dynamic incompatibilities;

  @HiveField(22)
  List<String> deliverableIngredients;

  @HiveField(23)
  List<dynamic> undeliverableIngredients;

  MealEntity({
    required this.id,
    required this.fats,
    required this.name,
    required this.time,
    required this.image,
    required this.weeks,
    required this.carbos,
    required this.fibers,
    required this.rating,
    required this.country,
    required this.ratings,
    required this.calories,
    required this.headline,
    required this.keywords,
    required this.products,
    required this.proteins,
    required this.favorites,
    required this.difficulty,
    required this.description,
    required this.highlighted,
    required this.ingredients,
    required this.incompatibilities,
    required this.deliverableIngredients,
    required this.undeliverableIngredients,
  });
}
