import 'package:deep_sight_ai_labs/constants/constant.dart';
import 'package:deep_sight_ai_labs/enum/connection_status.dart';
import 'package:deep_sight_ai_labs/pages/dashboard_page/widget/dashboard_sort_modal.dart';
import 'package:deep_sight_ai_labs/pages/dashboard_page/widget/dashboard_table.dart';
import 'package:deep_sight_ai_labs/pages/dashboard_page/widget/dashboard_top_section.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:provider/provider.dart';

import '../../provider/dashboard_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    var provider = Provider.of<DashboardProvider>(context, listen: false);
    provider.loadDashboard();
    provider.loadDashboardFilter();
    provider.initDashboardStream();
    super.initState();
  }

  int currPage = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            InkWell(
              onTap: () {
                var provider =
                    Provider.of<DashboardProvider>(context, listen: false);
                provider.loadDashboard();
              },
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person),
              ),
            ),
            SizedBox(
              width: 12,
            )
          ],
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(
            "Dashboard",
          ),
        ),
        body: Consumer<DashboardProvider>(
            builder: (context, dashboardProvider, _) {
          return dashboardProvider.connectionStatus == ConnectionStatus.active
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 12,
                            ),
                            DashboardTopSection(
                                countData: dashboardProvider
                                    .dashboardModel.data.countData),
                            const SizedBox(
                              height: 6,
                            ),
                            Row(
                              children: [
                                Text(
                                  "Feature Alerts",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20,
                                      color: Theme.of(context).primaryColor),
                                ),
                                const Spacer(),
                                Container(
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                  child: DropdownButton(
                                    value: dashboardProvider.selectedPageCount,
                                    icon: const Icon(Icons.keyboard_arrow_down),
                                    items: dashboardProvider.pageSizes
                                        .map((int items) {
                                      return DropdownMenuItem(
                                        value: items,
                                        child: Text(items.toString()),
                                      );
                                    }).toList(),
                                    onChanged: (newValue) {
                                      dashboardProvider.switchPageSize(newValue ??
                                          dashboardProvider.selectedPageCount);
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  width: 18,
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    showMaterialModalBottomSheet(
                                      context: context,
                                      builder: (context) => DashboardSortModal(
                                          filterList: dashboardProvider
                                              .dashboardFilterModel.data),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Theme.of(context).primaryColor),
                                  child: const Text(
                                    "Filter",
                                    style: TextStyle(),
                                  ),
                                )
                              ],
                            ),
                            if (dashboardProvider.dateRange != null)
                              InkWell(
                                onTap: () {
                                  dashboardProvider.resetFilter();
                                },
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(.3),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(18))),
                                  child:Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                        "${ Constant().getFormattedTime(time: dashboardProvider.dateRange!.start)} - ${Constant().getFormattedTime(time: dashboardProvider.dateRange!.end)}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500),
                                      ),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Icon(
                                        Icons.close,
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyText1!
                                            .color!
                                            .withOpacity(.99),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            if (dashboardProvider.selectedFilterName != "")
                              InkWell(
                                onTap: () {
                                  dashboardProvider.resetFilter();
                                },
                                child: Container(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                        dashboardProvider.selectedFilterName,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500),
                                      ),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Icon(
                                        Icons.close,
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyText1!
                                            .color!
                                            .withOpacity(.99),
                                      )
                                    ],
                                  ),
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(.3),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(18))),
                                ),
                              )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),

                      DashboardTable(
                          alertData:
                              dashboardProvider.dashboardModel.jsonData,
                        dashboardModel: dashboardProvider.dashboardModel,),
                      SizedBox(
                        height: 6,
                      ),

                      Text(
                        "Showing ${currPage} out ${dashboardProvider.totalPageCount} pages",
                        style: TextStyle(fontSize: 14),
                      ),
                      NumberPaginator(
                        numberPages: dashboardProvider.totalPageCount,
                        onPageChange: (int index) {

                          setState(() {
                            currPage = index + 1;
                          });
                          dashboardProvider.loadDashboard(pageIndex: index);
                        },
                        initialPage: dashboardProvider.initialPage,
                        config: NumberPaginatorUIConfig(
                            buttonSelectedBackgroundColor:
                                Theme.of(context).primaryColor),
                      ),
                      SizedBox(
                        height: 10,
                      )
                    ],
                  ),
              );
        }));
  }
}
