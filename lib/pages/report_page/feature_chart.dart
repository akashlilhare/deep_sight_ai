import 'package:deep_sight_ai_labs/enum/connection_status.dart';
import 'package:deep_sight_ai_labs/model/feature_data_model.dart' as fdm;
import 'package:deep_sight_ai_labs/provider/report_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/constant.dart';
import '../dashboard_page/widget/range_selector.dart';
import 'feature_chart_detail.dart';

class PieChartWidget extends StatefulWidget {
  final fdm.Data data;

  const PieChartWidget({Key? key, required this.data}) : super(key: key);

  @override
  State<PieChartWidget> createState() => _PieChartWidgetState();
}

class _PieChartWidgetState extends State<PieChartWidget> {
  @override
  void initState() {
    var provider = Provider.of<ReportProvider>(context, listen: false);
    provider.initFeatureData();
    super.initState();
  }


  int getTotal(){
   List<int> dataList = widget.data.y;
   int total = 0;
   for(int i =0 ; i< dataList.length ; i++){
     total += dataList[i];
   }
   return total;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ReportProvider>(builder: (context, reportProvider, _) {
      if (reportProvider.filterConnectionStatus == ConnectionStatus.active) {
        return Container(
          height: 700,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      } else {
        return Column(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 12.0, top: 10),
                  child: Row(
                    children: const [
                      Text(
                        "Feature vs Alerts",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                      Spacer(),
                      SizedBox(
                        width: 8,
                      )
                    ],
                  ),
                ),
                AspectRatio(
                    aspectRatio: 1.5,
                    child: Column(
                      children: [
                        Expanded(
                          child: PieChart(PieChartData(
                            sections: _chartSections(widget.data),
                            centerSpaceRadius: 48.0,
                          )),
                        ),

                        Text(
                          "Total Alerts: ${getTotal()}",
                          style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),
                        ),
                      ],
                    )),
              ],
            ),
            SizedBox(
              height: 18,
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 12,).copyWith(
                right: 12,left: 6
              ),
              color: Colors.red.withOpacity(.1),
              child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 18,
                  mainAxisSpacing: 12.0,
                  childAspectRatio: 11 / 2,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 18.0),
                      child: InkWell(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (builder) {
                                return RangeDatePicker();
                              });
                        },
                        child: IntrinsicWidth(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [

                              Row(


                                children: [
                                  Container(
                                    child: Text(
                                      "Select Range",
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  Spacer(),
                                  Icon(Icons.arrow_drop_down),
                                ],
                              ),
                              SizedBox(
                                height: 0,
                              ),
                              Container(
                                height: .7,
                                color: Colors.black.withOpacity(.15),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    ...reportProvider.featureFilterModel!.data.map(
                      (filter) {
                        int index = reportProvider.featureFilterModel!.data
                            .indexOf(filter);
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 18.0),
                            child: DropdownButton(
                              isExpanded: true,
                              value: filter.values[filter.selectedId],

                              items: filter.values.map((String items) {
                                return DropdownMenuItem(
                                  value: items,
                                  child: Text(items.toString()),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                if (newValue != null) {
                                  reportProvider.switchFeatureFilter(
                                      filterIdx: index,
                                      filterValueIdx:
                                          filter.values.indexOf(newValue));
                                }
                              },
                            ),
                          ),
                        );
                      },
                    ).toList(),
                  ]),
            ),
            Container(height: 1,color: Colors.grey.withOpacity(.1),),

            SizedBox(
              height: 12,
            ),
            FeatureChartDetail(data: reportProvider.featureDataModel!.data),
            SizedBox(
              height: 6,
            ),
          ],
        );
      }
    });
  }

  List<PieChartSectionData> _chartSections(fdm.Data sectors) {
    final List<PieChartSectionData> list = [];
    for (int i = 0; i < sectors.x.length; i++) {
      const double radius = 40.0;
      final data = PieChartSectionData(
        color: sectors.colors[i].withOpacity(.7),
        value: sectors.y[i].toDouble(),
        radius: radius,
        title: "",
      );
      list.add(data);
    }
    return list;
  }
}
