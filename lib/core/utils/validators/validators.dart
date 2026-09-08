class Validators {
  Validators._();

  static final RegExp _emailRegex = RegExp(r'^[\w.\-]+@([\w-]+\.)+[\w-]{2,4}$');

  static String? required(String? value, {String fieldName = 'This field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    if (!_emailRegex.hasMatch(value.trim())) {
      return 'Enter a valid email address';
    }
    return null;
  }

  static String? password(String? value, {int minLength = 6}) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < minLength) {
      return 'Password must be at least $minLength characters';
    }
    return null;
  }

  static String? match(
    String? value,
    String other, {
    String message = 'Values do not match',
  }) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    if (value != other) {
      return message;
    }
    return null;
  }
}
