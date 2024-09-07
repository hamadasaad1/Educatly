bool isValidEmail(String email) {
  return RegExp(
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
      .hasMatch(email);
}

bool isPhoneNoValid(String? phoneNo) {
  if (phoneNo == null) return false;
  // final regExp = RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)');
  final RegExp regExp = RegExp(r'^[0-9]{10}$');
  return regExp.hasMatch(phoneNo);
}

String? validatePassword(String? value) {
  if (value == null) return "Password is required";
  // RegExp regex =
  //     RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
  if (value.isEmpty) {
    return "Password is required";
  } else {
    if (value.trim().length < 6) {
      return "Password must be more than 6 characters";
    } else {
      return null;
    }
  }
}

String? validateConfirmPassword(String? value, String? confirmPassword) {
  if (value == null) return 'Please enter password';
  // RegExp regex =
  //     RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
  if (value.isEmpty) {
    return 'Please enter password';
  } else if (value.trim().length < 6) {
    return 'Enter valid password';
  } else if (value != confirmPassword) {
    return 'Password not match';
  } else {
    return null;
  }
}

bool isValidNumber(String value) {
  const integerPattern = r'^-?[0-9]+$';
  const doublePattern = r'^-?[0-9]+(\.[0-9]+)?$';
  final integerRegExp = RegExp(integerPattern);
  final doubleRegExp = RegExp(doublePattern);

  return integerRegExp.hasMatch(value) || doubleRegExp.hasMatch(value);
}
