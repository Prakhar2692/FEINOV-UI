import 'package:flutter_test/flutter_test.dart';
import 'package:feinov_ui/core/utils/validators.dart';

void main() {
  group('AppValidators', () {
    test('required returns error for empty values', () {
      expect(
        AppValidators.required('', fieldName: 'Email'),
        'Email is required',
      );
      expect(
        AppValidators.required('   ', fieldName: 'Password'),
        'Password is required',
      );
      expect(
        AppValidators.required('demo@feinov.com', fieldName: 'Email'),
        isNull,
      );
    });

    test(
      'email validation accepts valid addresses and rejects invalid values',
      () {
        expect(AppValidators.email('user@feinov.com'), isNull);
        expect(
          AppValidators.email('invalid-email'),
          'Enter a valid email address',
        );
        expect(AppValidators.email(''), 'Email is required');
      },
    );

    test('phone validation accepts a valid 10-digit number', () {
      expect(AppValidators.phone('9876543210'), isNull);
      expect(
        AppValidators.phone('12345'),
        'Enter a valid 10-digit mobile number',
      );
      expect(AppValidators.phone(''), 'Phone number is required');
    });

    test(
      'password validation enforces length and numeric/alpha requirements',
      () {
        expect(AppValidators.password('Pass1234'), isNull);
        expect(
          AppValidators.password('short'),
          'Password must be at least 8 characters',
        );
        expect(
          AppValidators.password('password'),
          'Password must contain letters and numbers',
        );
        expect(AppValidators.password(''), 'Password is required');
      },
    );
  });
}
