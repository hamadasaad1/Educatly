part of 'home_cubit.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}

//KDS ORDERS STATE
class HomeMealLoadingState extends HomeState {
  HomeMealLoadingState();
}

class HomeMealErrorState extends HomeState {
  final Failure failure;

  HomeMealErrorState({
    required this.failure,
  });
}

class HomeMealSuccessState extends HomeState {
  final List<MealEntity> entity;

  HomeMealSuccessState({
    required this.entity,
  });
}

class HomeMealFavoriteState extends HomeState {}
