import 'package:template/features/home/data/responses/meal_response.dart';

import '../../../../app/network/api_app.dart';

abstract class HomeRemoteDataSource {
  Future<List<MealResponse>> getMeals();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final AppServiceClient _serviceClient;

  HomeRemoteDataSourceImpl(this._serviceClient);

  @override
  Future<List<MealResponse>> getMeals() async {
    return await _serviceClient.getMeals();
  }
}
