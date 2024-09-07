import 'dart:ffi';

import 'package:bloc/bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meta/meta.dart';

import '../../../../app/error/failure.dart';
import '../../../../app/service_locator.dart';
import '../../domain/model/meal_entity.dart';
import '../../domain/useCase/home_useCase.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  late Box<MealEntity> mealBox;

  final HomeGetAllMealsUseCase _kdsGetAllOrdersUseCase =
      locator<HomeGetAllMealsUseCase>();

  void initialHive() async {
    if (!Hive.isBoxOpen('meals')) {
      mealBox = await Hive.openBox<MealEntity>('meals');
    } else {
      mealBox = Hive.box<MealEntity>('meals');
    }
  }

  void getMeals() async {
    emit(HomeMealLoadingState());
    (await _kdsGetAllOrdersUseCase.execute(Void)).fold((failure) {
      return {emit(HomeMealErrorState(failure: failure))};
    }, (data) {
      emit(HomeMealSuccessState(entity: data));
    });
  }

  void saveFavorite(MealEntity meal) {
    mealBox.put(meal.id, meal);
    emit(HomeMealFavoriteState());
  }

  List<MealEntity> getFavorites() {
    mealBox = Hive.box<MealEntity>('meals');

    return mealBox.values.toList();
  }

  void toggleFavorite(MealEntity model) {
    if (mealBox.containsKey(model.id)) {
      mealBox.delete(model.id);
    } else {
      mealBox.put(model.id, model);
    }
    emit(HomeMealFavoriteState());
  }
}
