import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/core/features/report/domain/entities/report.dart';

class ReportCubit extends Cubit<List<Report>> {
  ReportCubit() : super([]);

  void initializeReports(List<Report> reports) {
    emit(reports);
  }

  void addReport(Report report) {
    emit([...state, report]);
  }

  void emptyReports() {
    emit([]);
  }
}
