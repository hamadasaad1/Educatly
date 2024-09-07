import 'package:dartz/dartz.dart';
import 'package:template/features/home/domain/model/meal_entity.dart';

import '../../../../app/error/failure.dart';

abstract class HomeRepository {
  Future<Either<Failure, List<MealEntity>>> getMeals();
}
