

import 'package:deep_sight_ai_labs/model/dashboard_model.dart';
import 'package:deep_sight_ai_labs/provider/dashboard_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/constant.dart';

class DashboardTopSection extends StatelessWidget {
  final List<CountData> countData;

  const DashboardTopSection({Key? key, required this.countData}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;


    buildCard({required String title, required String subtitle}) {
      return Expanded(
        child: Container(
          margin: EdgeInsets.only(right: 12),
          width: width * .65,
          decoration: Constant().boxDecoration.copyWith(
            color: Theme.of(context).cardColor
          ),
          child: InkWell(
            onTap: (){
              Provider.of<DashboardProvider>(context,listen: false).applyFilter(filter: title, tag: "feature_type");
            },
            child: IntrinsicHeight(
              child: Row(
                children: [
                  Container(
                    width: 8,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        bottomLeft: Radius.circular(12),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Spacer(),
                      Row(
                        children: [
                          Text(
                            Constant().getFormattedTitle(title: title),
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                                           color: Theme.of(context).primaryColor,

                            ),
                          ),
                          Icon(Icons.arrow_forward,color: Theme.of(context).primaryColor,)
                        ],
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Text(
                        subtitle,
                        style: TextStyle(
                            fontSize: 22,
                            color: Theme.of(context).textTheme.bodyText1!.color!.withOpacity(.8),
                            fontWeight: FontWeight.w400),
                      ),
                      Spacer(),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      );
    }

    return  Container(
      height: 120,
      child: Scrollbar(
        child: ListView(
          padding: EdgeInsets.only(bottom: 12, top: 4),
          scrollDirection: Axis.horizontal,
          children: [
            ...countData.map((item) =>
                buildCard(title: item.featureType, subtitle: item.count.toString()))
          ],
        ),
      ),
    );
  }
}


class DashboardTempModel {
  final String title;
  final String data;

  DashboardTempModel({required this.title, required this.data});
}
