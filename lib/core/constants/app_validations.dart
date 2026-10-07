class AppValidations {
  const AppValidations._();

  static const int minNameLength = 2;
  static const int minPasswordLength = 8;
  static const int maxAddressLength = 200;

  static const String emailPattern =
      r'^[a-zA-Z0-9.!#$%&*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$';

  static const String indianPhonePattern = r'^[6-9]\d{9}$';

  static const String passwordPattern = r'^(?=.*[A-Za-z])(?=.*\d).{8,}$';
}
