import 'package:flutter/cupertino.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class AnalyticsTest extends StatelessWidget {
  const AnalyticsTest({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 400,
      child: SfCartesianChart(
          // Initialize category axis
          primaryXAxis: CategoryAxis(),
          series: <LineSeries<GenderData, String>>[
            LineSeries<GenderData, String>(
                // Bind data source
                dataSource: <GenderData>[
                  GenderData('Male', 35),
                  GenderData('Female', 28),
                ],
                xValueMapper: (GenderData sales, _) => sales.gender,
                yValueMapper: (GenderData sales, _) => sales.count)
          ]),
    );
  }
}

class GenderData {
  final String gender;
  final int count;

  GenderData(this.gender, this.count);
}
