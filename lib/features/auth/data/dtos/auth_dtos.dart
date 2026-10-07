class LoginRequestDto {
  const LoginRequestDto({required this.email, required this.password});

  final String email;
  final String password;

  Map<String, dynamic> toJson() => {
    'email': email.trim(),
    'password': password,
  };
}

class RegisterRequestDto {
  const RegisterRequestDto({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.mobileNumber,
    required this.countryCode,
  });

  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String mobileNumber;
  final String countryCode;

  Map<String, dynamic> toJson() => {
    'firstName': firstName.trim(),
    'lastName': lastName.trim(),
    'email': email.trim(),
    'password': password,
    'mobileNumber': mobileNumber.trim(),
    'countryCode': countryCode,
  };
}

class ForgotPasswordRequestDto {
  const ForgotPasswordRequestDto({required this.email});

  final String email;

  Map<String, dynamic> toJson() => {'email': email.trim()};
}

class VerifyEmailRequestDto {
  const VerifyEmailRequestDto({required this.email, required this.otp});

  final String email;
  final String otp;

  Map<String, dynamic> toJson() => {'email': email.trim(), 'otp': otp.trim()};
}

class AuthResponseDto {
  const AuthResponseDto({required this.token, required this.user});

  final String token;
  final Map<String, dynamic> user;

  factory AuthResponseDto.fromJson(Map<String, dynamic> json) {
    return AuthResponseDto(
      token: (json['token'] ?? json['accessToken'] ?? '').toString(),
      user: Map<String, dynamic>.from(json['user'] ?? {}),
    );
  }
}
