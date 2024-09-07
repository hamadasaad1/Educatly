// To parse this JSON data, do
//
//     final mealResponse = mealResponseFromJson(jsonString);

import 'dart:convert';

List<MealResponse> mealResponseFromJson(String str) => List<MealResponse>.from(
    json.decode(str).map((x) => MealResponse.fromJson(x)));

class MealResponse {
  String? id;
  String? fats;
  String? name;
  String? time;
  String? image;
  List<String>? weeks;
  String? carbos;
  String? fibers;
  double? rating;
  String? country;
  int? ratings;
  String? calories;
  String? headline;
  List<String>? keywords;
  List<String>? products;
  String? proteins;
  int? favorites;
  int? difficulty;
  String? description;
  bool? highlighted;
  List<String>? ingredients;
  dynamic incompatibilities;
  List<String>? deliverableIngredients;
  List<dynamic>? undeliverableIngredients;

  MealResponse({
    this.id,
    this.fats,
    this.name,
    this.time,
    this.image,
    this.weeks,
    this.carbos,
    this.fibers,
    this.rating,
    this.country,
    this.ratings,
    this.calories,
    this.headline,
    this.keywords,
    this.products,
    this.proteins,
    this.favorites,
    this.difficulty,
    this.description,
    this.highlighted,
    this.ingredients,
    this.incompatibilities,
    this.deliverableIngredients,
    this.undeliverableIngredients,
  });

  factory MealResponse.fromJson(Map<String, dynamic> json) => MealResponse(
        id: json["id"],
        fats: json["fats"],
        name: json["name"],
        time: json["time"],
        image: json["image"],
        weeks: json["weeks"] != null
            ? List<String>.from(json["weeks"].map((x) => x))
            : [],
        carbos: json["carbos"],
        fibers: json["fibers"],
        rating: json["rating"] != null
            ? double.parse(json["rating"].toString())
            : 0.0,
        country: json["country"],
        ratings: json["ratings"],
        calories: json["calories"],
        headline: json["headline"],
        keywords: json["keywords"] != null
            ? List<String>.from(json["keywords"].map((x) => x))
            : [],
        products: json["products"] != null
            ? List<String>.from(json["products"].map((x) => x))
            : [],
        proteins: json["proteins"],
        favorites: json["favorites"],
        difficulty: json["difficulty"],
        description: json["description"],
        highlighted: json["highlighted"],
        ingredients: json["ingredients"] != null
            ? List<String>.from(json["ingredients"].map((x) => x))
            : [],
        incompatibilities: json["incompatibilities"],
        deliverableIngredients: json["deliverable_ingredients"] != null
            ? List<String>.from(json["deliverable_ingredients"].map((x) => x))
            : [],
        undeliverableIngredients: json["undeliverable_ingredients"] != null
            ? List<String>.from(json["undeliverable_ingredients"].map((x) => x))
            : [],
      );
}
