import '../models/profile.dart';

abstract class ProfileRepository {
  Future<UserProfile> fetchProfile();
  Future<UserProfile> updateProfile({required Map<String, dynamic> payload});
  Future<List<Address>> fetchAddresses();
  Future<Address> saveAddress({required Map<String, dynamic> payload});
  Future<void> signOut();
}
