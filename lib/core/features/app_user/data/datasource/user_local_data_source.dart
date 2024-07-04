import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:myapp/core/error/exceptions.dart';
import 'package:myapp/core/features/app_user/data/models/user_model.dart';

abstract interface class UserLocalDataSource {
  Future<void> submitUserData(UserModel userModel);
  UserModel fetchUserData();
}

class UserLocalDataSourceImpl implements UserLocalDataSource {
  final Box<UserModel> box;

  UserLocalDataSourceImpl(this.box);
  @override
  UserModel fetchUserData() {
    try {
      return box.get(0)!;
    } catch (e, stack) {
      print(e.toString());
      log(stack.toString());
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> submitUserData(UserModel userModel) async {
    try {
      box.clear();
      await box.put(0, userModel);
    } catch (e) {
      print(e.toString());
      throw ServerException(e.toString());
    }
  }
}
