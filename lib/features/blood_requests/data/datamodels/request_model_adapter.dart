import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:myapp/features/blood_requests/data/datamodels/request_model.dart';

class RequestModelAdapter extends TypeAdapter<RequestModel> {
  @override
  RequestModel read(BinaryReader reader) {
    // Use your existing fromJson logic
    var jsonString = reader.readString();
    var jsonMap = json.decode(jsonString);
    return RequestModel.fromJson(jsonMap, true);
  }

  @override
  final typeId = 2; // this must be unique within project

  @override
  void write(BinaryWriter writer, RequestModel obj) {
    // Use your existing toJson logic
    var jsonString = json.encode(obj.toJson(true));
    writer.writeString(jsonString);
  }
}
