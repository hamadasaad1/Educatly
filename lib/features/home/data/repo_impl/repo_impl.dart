import 'package:dartz/dartz.dart';
import 'package:template/features/home/data/mapper/mapper_meals.dart';

import '../../../../app/error/error_handler.dart';
import '../../../../app/error/failure.dart';
import '../../../../app/network/network_info.dart';
import '../../domain/model/meal_entity.dart';
import '../../domain/repo/repository.dart';
import '../remote_data_source/home_remote_data_source.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  HomeRepositoryImpl(this._remoteDataSource, this._networkInfo);

  @override
  Future<Either<Failure, List<MealEntity>>> getMeals() async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _remoteDataSource.getMeals();
        List<MealEntity> list = response.map((e) => e.toDomain()).toList();
        return Right(list);
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }
}
