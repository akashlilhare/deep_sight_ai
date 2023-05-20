

import 'package:deep_sight_ai_labs/model/feature_data_model.dart' as fdm;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../main_page.dart';
import '../../provider/dashboard_provider.dart';

class CameraChartDetail extends StatelessWidget {
  final fdm.Data data;

  const CameraChartDetail({Key? key, required this.data}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...data.x.map((sector) {
          int index = data.x.indexOf(sector);
          return InkWell(
            onTap: (){
              Provider.of<DashboardProvider>(context, listen: false)
                  .applyFilter(
                  filter: data.x[index].toString(), tag: "camera_name");

              Navigator.of(context)
                  .pushReplacement(MaterialPageRoute(builder: (builder) {
                return MainPage();
              }));
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 16),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: data.colors[index].withOpacity(.7)),
                    height: 16,
                    width: 16,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                      child: Row(
                        children: [
                          Text(
                            data.x[index].toString(),
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .color!
                                    .withOpacity(.8)),
                          ),
                          SizedBox(width: 8,),
                          Icon(Icons.arrow_forward,size: 18,)
                        ],
                      )),
                  Text(
                    data.y[index].toInt().toString(),
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .color!
                            .withOpacity(.8)),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ],
    );
  }
}
