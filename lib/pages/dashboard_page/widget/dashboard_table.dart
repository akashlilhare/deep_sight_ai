import 'package:deep_sight_ai_labs/constants/constant.dart';
import 'package:deep_sight_ai_labs/pages/dashboard_page/dshboard_detail_page.dart';
import 'package:deep_sight_ai_labs/provider/dashboard_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../model/dashboard_model.dart';

class DashboardTable extends StatelessWidget {
  final Map<String, dynamic> alertData;
  final DashboardModel dashboardModel;

  const DashboardTable({Key? key, required this.alertData, required this.dashboardModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    buildDetail(
        {required String title, required String subtitle, Color? color}) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 1.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 4,
              child: Text(
                title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
            Expanded(
              flex: 5,
              child: Text(
                subtitle,
                style: TextStyle(
                    fontSize: 16,
                    color: color ??
                        Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .color!
                            .withOpacity(.8),
                    fontWeight: FontWeight.w500),
              ),
            )
          ],
        ),
      );
    }



    buildCardItem(
        {required List<dynamic> tagList,
        required List<dynamic> dataList,
        required int index}) {
      return
          // Text(tagList.toString());

          InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (builder) {
            return DashboardDetailPage(
              dashboardProvider: dashboardModel.data.alertData[index] ,
              jsonData: alertData,
              index: index,
            );
          }));
        },
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 18, left: 12, right: 12),
              decoration: Constant().boxDecoration.copyWith(
                  color: Theme.of(context).cardColor,
                  border: Provider.of<DashboardProvider>(context, listen: false)
                          .isNewCard(id: dataList[index]["ID"])
                      ? Border.all(color: Theme.of(context).primaryColor)
                      : null),
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (int i = 0; i < tagList.length; i++)
                    ...{
                      if (tagList[i].toString() != "alert_timestamp")
                        buildDetail(
                            title: Constant().getFormattedTitle(
                                title: tagList[i].toString()),
                            subtitle: dataList[index][tagList[i].toString()]
                                .toString())
                    }.toList(),
                  buildDetail(
                      title: "Alert Time",
                      subtitle: DateFormat.yMEd().add_jm().format(
                          DateTime.parse(dataList[index]["alert_timestamp"])),
                      color: Color(0xffC3A800)),
                ],
              ),
            ),
            Positioned(
                right: 12,
                child: Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(8),
                            bottomLeft: Radius.circular(8),
                            bottomRight: Radius.circular(2),
                            topLeft: Radius.circular(2))),
                    padding: EdgeInsets.symmetric(horizontal: 9, vertical: 9),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: 18,
                    )))
          ],
        ),
      );
    }

    return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: alertData["data"]["alert_data"].length,
        itemBuilder: (context, index) {
          var tagList = alertData["data"]["alert_card"];
          var dataList = alertData["data"]["alert_data"];
          return buildCardItem(
              tagList: tagList, dataList: dataList, index: index);

        });
  }
}
