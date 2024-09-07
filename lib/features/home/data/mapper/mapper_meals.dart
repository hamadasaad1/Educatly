import 'package:template/features/home/data/responses/meal_response.dart';
import 'package:template/features/home/domain/model/meal_entity.dart';

import '../../../../app/constants.dart';
import '../../../../app/extensions.dart';

extension MealResponseMapper on MealResponse? {
  MealEntity toDomain() {
    return MealEntity(
      id: this?.id.orEmpty() ?? Constants.empty,
      calories: this?.calories.orEmpty() ?? Constants.empty,
      description: this?.description.orEmpty() ?? Constants.empty,
      fats: this?.fats.orEmpty() ?? Constants.empty,
      headline: this?.headline.orEmpty() ?? Constants.empty,
      image: this?.image.orEmpty() ?? Constants.empty,
      name: this?.name.orEmpty() ?? Constants.empty,
      proteins: this?.proteins.orEmpty() ?? Constants.empty,
      time: this?.time.orEmpty() ?? Constants.empty,
      carbos: this?.carbos.orEmpty() ?? Constants.empty,
      fibers: this?.fibers.orEmpty() ?? Constants.empty,
      rating: this?.rating.orZero() ?? 0,
      country: this?.country.orEmpty() ?? Constants.empty,
      ratings: this?.ratings.orZero() ?? Constants.zero,
      weeks: this?.weeks?.map((e) => e.orEmpty()).toList() ?? [],
      keywords: this?.keywords?.map((e) => e.orEmpty()).toList() ?? [],
      products: this?.products?.map((e) => e.orEmpty()).toList() ?? [],
      favorites: this?.favorites.orZero() ?? Constants.zero,
      difficulty: this?.difficulty.orZero() ?? Constants.zero,
      incompatibilities: Constants.empty,
      deliverableIngredients:
          this?.deliverableIngredients?.map((e) => e.orEmpty()).toList() ?? [],
      undeliverableIngredients:
          this?.undeliverableIngredients?.map((e) => e.orEmpty()).toList() ??
              [],
      highlighted: this?.highlighted.orBool() ?? Constants.isEmpty,
      ingredients: this?.ingredients?.map((e) => e.orEmpty()).toList() ?? [],
    );
  }
}
