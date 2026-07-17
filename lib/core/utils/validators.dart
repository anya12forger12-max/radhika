import 'package:radhika/core/constants/app_constants.dart';

class Validators {
  Validators._();

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < AppConstants.minPasswordLength) {
      return 'Password must be at least ${AppConstants.minPasswordLength} characters';
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain an uppercase letter';
    }
    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain a lowercase letter';
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain a number';
    }
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    }
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  static String? validateAge(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Age is required';
    }
    final age = int.tryParse(value.trim());
    if (age == null) {
      return 'Please enter a valid number';
    }
    if (age < AppConstants.minAge || age > AppConstants.maxAge) {
      return 'Age must be between ${AppConstants.minAge} and ${AppConstants.maxAge}';
    }
    return null;
  }

  static String? validateCycleLength(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final length = int.tryParse(value.trim());
    if (length == null) return 'Please enter a valid number';
    if (length < AppConstants.minCycleLength ||
        length > AppConstants.maxCycleLength) {
      return 'Cycle length must be between ${AppConstants.minCycleLength} and ${AppConstants.maxCycleLength} days';
    }
    return null;
  }

  static String? validatePeriodLength(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final length = int.tryParse(value.trim());
    if (length == null) return 'Please enter a valid number';
    if (length < AppConstants.minPeriodLength ||
        length > AppConstants.maxPeriodLength) {
      return 'Period length must be between ${AppConstants.minPeriodLength} and ${AppConstants.maxPeriodLength} days';
    }
    return null;
  }
}
