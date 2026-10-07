import 'package:dio/dio.dart';

import '../../../../core/constants/app_endpoints.dart';
import '../../data/dtos/home_dtos.dart';
import '../../domain/models/home_models.dart';
import '../../domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  const HomeRepositoryImpl(this.dio);

  final Dio dio;

  @override
  Future<HomePageData> fetchHomeData() async {
    try {
      final response = await dio.get(AppEndpoints.home);
      final rawData = response.data;
      final data = rawData is Map<String, dynamic>
          ? rawData
          : rawData is Map
          ? Map<String, dynamic>.from(rawData)
          : <String, dynamic>{};

      if (data.isEmpty) {
        return HomePageData.fallback();
      }

      return HomeApiResponseDto.fromJson(data).toDomain();
    } on DioException {
      return HomePageData.fallback();
    }
  }
}
