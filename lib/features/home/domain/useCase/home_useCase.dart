import 'package:dartz/dartz.dart';
import 'package:template/features/home/domain/model/meal_entity.dart';

import '../../../../app/error/failure.dart';
import '../../../../app/usecase/base_usecase.dart';
import '../repo/repository.dart';

class HomeGetAllMealsUseCase implements BaseUseCase<void, List<MealEntity>> {
  final HomeRepository _repository;

  HomeGetAllMealsUseCase(
    this._repository,
  );

  @override
  Future<Either<Failure, List<MealEntity>>> execute(Void) async {
    return await _repository.getMeals();
  }
}
