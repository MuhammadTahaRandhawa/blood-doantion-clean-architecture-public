import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:myapp/core/features/app_user/data/models/user_model.dart';

class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  UserModel read(BinaryReader reader) {
    final jsonString = reader.readString();
    final jsonMap = json.decode(jsonString);
    return UserModel.fromJson(jsonMap, true);
  }

  @override
  final int typeId = 1;

  @override
  void write(BinaryWriter writer, UserModel obj) {
    final jsonString = json.encode(obj.toJson(true));
    writer.writeString(jsonString);
  }
}
