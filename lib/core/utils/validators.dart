import '../constants/app_validations.dart';

class AppValidators {
  const AppValidators._();

  static String? required(String? value, {String fieldName = 'Field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  static String? email(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) return 'Email is required';
    final regex = RegExp(AppValidations.emailPattern);
    if (!regex.hasMatch(trimmed)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  static String? phone(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) return 'Phone number is required';
    final regex = RegExp(AppValidations.indianPhonePattern);
    if (!regex.hasMatch(trimmed)) {
      return 'Enter a valid 10-digit mobile number';
    }
    return null;
  }

  static String? password(String? value) {
    final trimmed = value ?? '';
    if (trimmed.isEmpty) return 'Password is required';
    if (trimmed.length < AppValidations.minPasswordLength) {
      return 'Password must be at least 8 characters';
    }
    final regex = RegExp(AppValidations.passwordPattern);
    if (!regex.hasMatch(trimmed)) {
      return 'Password must contain letters and numbers';
    }
    return null;
  }
}
