import 'package:deep_sight_ai_labs/pages/report_page/feature_chart.dart';
import 'package:deep_sight_ai_labs/provider/report_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../enum/connection_status.dart';
import 'camera_chart.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({Key? key}) : super(key: key);

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  @override
  void initState() {
    var provider = Provider.of<ReportProvider>(context, listen: false);
    provider.initFeatureData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text("Report"),
        actions: [
          CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(Icons.person),
          ),
          SizedBox(
            width: 12,
          )
        ],
      ),
      body: Consumer<ReportProvider>(builder: (context, reportProvider, _) {
        if (reportProvider.featureDataModel == null ||
            reportProvider.cameraDataModel == null ||
            reportProvider.cameraFilterModel == null ||
            reportProvider.featureFilterModel == null
          ) {
          return Center(child: CircularProgressIndicator());
        } else {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PieChartWidget(data: reportProvider.featureDataModel!.data),
                Container(
                  height: 20,
                  color: Colors.grey.withOpacity(.2),
                ),
                CameraChartWidget(data: reportProvider.cameraDataModel!.data),
              ],
            ),
          );
        }
      }),
    );
  }
}
