import 'package:fpdart/fpdart.dart';
import 'package:myapp/core/utilis/app_regexp.dart';

class UserInformationValidator {
  phoneNoValidator(String? value) {
    if (value == '' || value!.trim().isEmpty) {
      return 'Phone Numeber Can\'t be empty';
    }

    if (value.trim().startsWith('0')) {
      if (value.trim().length > 11) {
        return 'phone Number length exceeded';
      } else if (value.trim().length < 11) {
        return 'phone Number length is smaller';
      }
      if (!AppRegExp.numberPattern.hasMatch(value)) {
        return 'Phone No. must be in Numbers Only';
      }
      return null;
    } else if (value.trim().startsWith('+')) {
      if (value.trim().length > 13) {
        return 'phone Number length exceeded';
      } else if (value.trim().length < 13) {
        return 'phone Number length is smaller';
      }
      if (!AppRegExp.numberPatternWithPlusAtStart.hasMatch(value)) {
        return 'Phone No. cant contain Alphabets';
      }
      return null;
    }

    return 'Please Enter a Correct Phone No.';
  }

  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password cannot be empty';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    if (!RegExp(r'^(?=.*[A-Z])').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!RegExp(r'^(?=.*[a-z])').hasMatch(value)) {
      return 'Password must contain at least one lowercase letter';
    }
    if (!RegExp(r'^(?=.*\d)').hasMatch(value)) {
      return 'Password must contain at least one number';
    }
    // if (!RegExp(r'^(?=.*[@$!%*#?&])').hasMatch(value)) {
    //   return 'Password must contain at least one special character (@, $, !, %, *, #, ?, &)';
    // }
    return null;
  }

  userNameValidator(String? value) {
    if (value == '' || value!.trim().isEmpty) {
      return 'User Name Can\'t be empty';
    }
    return null;
  }

  emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email cannot be empty';
    }
    // Regular expression pattern for validating email
    final emailPattern = AppRegExp.emailPattern;
    if (!emailPattern.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  cnicValidator(String? value) {
    if (value == '' || value!.trim().isEmpty) {
      return 'CNIC Can\'t be empty';
    }

    if (value.trim().length != 13) {
      return 'CNIC must be of 13 characters';
    }
    if (value.contains((RegExp(r'[A-Z]'))) ||
        value.contains((RegExp(r'[a-z]')))) {
      return 'CNIC must be in Numbers Only';
    }
    return null;
  }

  validateDOB(String? value) {
    if (value == null || value == '' || value.isEmpty || value.trim().isEmpty) {
      return 'Please Enter Your Date of Birth';
    }
    if (value.contains((AppRegExp.upperCaseLetter)) ||
        value.contains((AppRegExp.lowerCaseLetter))) {
      return 'Date of Birth should be in Numeric';
    }
    return null;
  }

  validateBloodBagsQuantity(String? value) {
    if (value == null || value == '' || value.trim() == '') {
      return 'Please enter number of bags you required';
    }
    if (!AppRegExp.numberPattern.hasMatch(value)) {
      return 'Blood Bags must be an integer';
    }
    if (int.parse(value) < 0 || int.parse(value) > 5) {
      return 'Number of bags must be between 1 and 5';
    }
    return null;
  }

  Either<String, Unit> validateBloodGroup(String? value) {
    if (value == null || value == '' || value.isEmpty) {
      return left('A Blood Group Must be Choosed');
    }
    return right(unit);
  }

  Either<String, Unit> validateGender(String? value) {
    if (value == null || value == '' || value.isEmpty) {
      return left('A Gender Must be Specified');
    }

    return right(unit);
  }

  Either<String, Unit> validateNonFormFieldValues(
      String? bloodGroup, String? gender) {
    var bloodGroupValidation = validateBloodGroup(bloodGroup);
    if (bloodGroupValidation.isLeft()) {
      return bloodGroupValidation;
    }

    var genderValidation = validateGender(gender);
    if (genderValidation.isLeft()) {
      return genderValidation;
    }

    return right(unit);
  }
}
