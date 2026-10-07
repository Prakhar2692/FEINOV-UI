import 'package:dio/dio.dart';

import '../../../../core/constants/app_endpoints.dart';
import '../../domain/models/profile.dart';
import '../../domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  const ProfileRepositoryImpl(this.dio);

  final Dio dio;

  @override
  Future<UserProfile> fetchProfile() async {
    final response = await dio.get(AppEndpoints.profile);
    final data = response.data is Map<String, dynamic>
        ? Map<String, dynamic>.from(response.data)
        : <String, dynamic>{};
    return UserProfile.fromJson(data);
  }

  @override
  Future<UserProfile> updateProfile({
    required Map<String, dynamic> payload,
  }) async {
    final response = await dio.patch(AppEndpoints.profile, data: payload);
    final data = response.data is Map<String, dynamic>
        ? Map<String, dynamic>.from(response.data)
        : <String, dynamic>{};
    return UserProfile.fromJson(data);
  }

  @override
  Future<List<Address>> fetchAddresses() async {
    final response = await dio.get(AppEndpoints.addresses);
    final items =
        response.data['items'] as List? ?? response.data as List? ?? const [];
    return items
        .map((item) => Address.fromJson(Map<String, dynamic>.from(item as Map)))
        .toList();
  }

  @override
  Future<Address> saveAddress({required Map<String, dynamic> payload}) async {
    final response = await dio.post(AppEndpoints.addresses, data: payload);
    final data = response.data is Map<String, dynamic>
        ? Map<String, dynamic>.from(response.data)
        : payload;
    return Address.fromJson(data);
  }

  @override
  Future<void> signOut() async {
    await dio.post(AppEndpoints.authLogout);
  }
}
