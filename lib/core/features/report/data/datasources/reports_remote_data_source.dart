import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:myapp/core/error/exceptions.dart';
import 'package:myapp/core/features/report/data/datamodel/report_model.dart';
import 'package:myapp/core/features/report/domain/entities/report.dart';

abstract interface class ReportsRemoteDataSource {
  Future<Unit> postAReportOnDonation(
      ReportModel reportModel, String donationId);
  Future<List<ReportModel>> fetchDonationReports(String donationId);
  Future<Unit> postAReportOnRequest(ReportModel reportModel, String requestId);
  Future<List<ReportModel>> fetchRequestReports(String requestId);
}

class ReportsRemoteDataSourceImpl implements ReportsRemoteDataSource {
  final FirebaseFirestore firebaseFirestore;

  ReportsRemoteDataSourceImpl(this.firebaseFirestore);
  @override
  Future<List<ReportModel>> fetchDonationReports(String donationID) async {
    try {
      final response = await firebaseFirestore
          .collection('donations')
          .doc(donationID)
          .collection('reports')
          .get();
      final reports = response.docs
          .map((e) => ReportModel.fromJson(e.data(), ReportType.donation))
          .toList();
      return reports;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<ReportModel>> fetchRequestReports(String requestID) async {
    try {
      final response = await firebaseFirestore
          .collection('requests')
          .doc(requestID)
          .collection('reports')
          .get();
      final reports = response.docs
          .map((e) => ReportModel.fromJson(e.data(), ReportType.request))
          .toList();
      return reports;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<Unit> postAReportOnDonation(
      ReportModel reportModel, String donationId) async {
    try {
      await firebaseFirestore
          .collection('donations')
          .doc(donationId)
          .collection('reports')
          .doc(reportModel.reportId)
          .set(reportModel.toJson(), SetOptions(merge: true));
      return (unit);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<Unit> postAReportOnRequest(
      ReportModel reportModel, String requestId) async {
    try {
      await firebaseFirestore
          .collection('requests')
          .doc(requestId)
          .collection('reports')
          .doc(reportModel.reportId)
          .set(reportModel.toJson(), SetOptions(merge: true));
      return (unit);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
