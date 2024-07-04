import 'dart:developer';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:myapp/core/error/exceptions.dart';
import 'package:myapp/features/blood_requests/data/datamodels/request_model.dart';

abstract interface class BloodRequestsLocalDataSource {
  List<RequestModel> fetchBloodRequestsLocally();
  Future<void> storeBloodRequestsLocally(List<RequestModel> requests);
  Future<void> storeSingleBloodRequestLocally(RequestModel requestModel);
}

class BloodRequestsLocalDataSourceImpl implements BloodRequestsLocalDataSource {
  final Box<RequestModel> box;

  BloodRequestsLocalDataSourceImpl(this.box);
  @override
  List<RequestModel> fetchBloodRequestsLocally() {
    try {
      List<RequestModel> requests = [];
      for (var i = 0; i < box.length; i++) {
        requests.add(box.get(i)!);
      }
      log(requests.toString());
      return requests;
    } catch (e) {
      print(e.toString());
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> storeBloodRequestsLocally(List<RequestModel> requests) async {
    try {
      box.clear();
      for (var request in requests) {
        await box.add(request);
      }
    } catch (e) {
      print(e.toString());
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> storeSingleBloodRequestLocally(RequestModel requestModel) async {
    try {
      await box.add(requestModel);
    } catch (e, stack) {
      print(e);
      log(stack.toString());
      throw ServerException(e.toString());
    }
  }
}
