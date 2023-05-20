import 'package:deep_sight_ai_labs/constants/constant.dart';
import 'package:deep_sight_ai_labs/pages/dashboard_page/widget/range_selector.dart';
import 'package:deep_sight_ai_labs/provider/dashboard_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

import '../../../model/dashboard_filter_model.dart';

class DashboardSortModal extends StatelessWidget {
  final List<Data> filterList;

  const DashboardSortModal({Key? key, required this.filterList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    buildTile({required String title, required List<String> filterValues}) {
      return ListTile(
        title: Text(title),
        trailing: Icon(Icons.filter_list),
        onTap: () {
          Navigator.of(context).pop();
          showMaterialModalBottomSheet(
            context: context,
            builder: (context) => DashboardFilterValueModal(
                title: title, filterList: filterValues),
          );
        },
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          ListTile(
            title: Row(
              children: [
                Text(
                  "Filter By",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  width: 4,
                ),
                Icon(
                  Icons.filter_alt_outlined,
                  color:Theme.of(context).textTheme.bodyText1!.color!.withOpacity(.9),
                ),
                Spacer(),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Icon(
                    Icons.close,
                    color:Theme.of(context).textTheme.bodyText1!.color!.withOpacity(.99),
                  ),
                ),
              ],
            ),
          ),
          Constant().getDivider(),
          ...filterList
              .map((filter) =>
                  buildTile(title: filter.title, filterValues: filter.values))
              .toList(),
          ListTile(
            trailing: Icon(Icons.filter_list),
            title: Text("Date Range"),
            onTap: () async {
              Navigator.of(context).pop();
              var provider = Provider.of<DashboardProvider>(context, listen:  false);
              DateTimeRange? timeRange = await showDialog(
                  context: context,
                  builder: (builder) {
                    return RangeDatePicker();
                  });

              if(timeRange != null){
               provider.applyDateFilter(d: timeRange);
              }
            },
          )
        ],
      ),
    );
  }
}

class DashboardFilterValueModal extends StatelessWidget {
  final List<String> filterList;
  final String title;

  const DashboardFilterValueModal(
      {Key? key, required this.filterList, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    buildTile({required String filterName}) {
      return ListTile(
        title: Text(filterName),
        onTap: () {
          var provider = Provider.of<DashboardProvider>(context, listen: false);
          provider.applyFilter(filter: filterName, tag: title);
          Navigator.of(context).pop();
        },
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          ListTile(
            title: Row(
              children: [
                Text(
                  "Filter By : $title",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                Spacer(),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Icon(
                    Icons.close,
                    color:Theme.of(context).textTheme.bodyText1!.color!.withOpacity(.99),
                  ),
                ),
              ],
            ),
          ),
          Constant().getDivider(),
          ...filterList.map((filter) => buildTile(filterName: filter)).toList(),
        ],
      ),
    );
  }
}
