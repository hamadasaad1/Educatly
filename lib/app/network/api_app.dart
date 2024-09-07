import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import 'package:template/features/home/data/responses/meal_response.dart';

part 'api_app.g.dart';

/// It's a Dart class that extends the RestApi class from the dio_rest_api package. It has a factory
/// constructor that takes a Dio object and a baseUrl.
@RestApi()
abstract class AppServiceClient {
  factory AppServiceClient(Dio dio, {String baseUrl}) = _AppServiceClient;

  @GET('43427003d33f1f6b51cc')
  Future<List<MealResponse>> getMeals();
}
