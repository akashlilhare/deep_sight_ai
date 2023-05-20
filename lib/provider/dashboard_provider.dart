import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../constants/constant.dart';
import '../enum/connection_status.dart';
import '../model/dashboard_filter_model.dart';
import '../model/dashboard_model.dart';

class DashboardProvider with ChangeNotifier {
  late DashboardModel dashboardModel;
  ConnectionStatus connectionStatus = ConnectionStatus.none;
  final Constant _constant = Constant();
  late DashboardFilterModel dashboardFilterModel;
  String selectedFilterName = "";
  String selectedFilterTag = "";

  int selectedPageCount = 20;
  int initialPage = 0;
  List<int> pageSizes = [20, 40, 60];
  int totalPageCount = 10;
  DateTimeRange? dateRange;
  int? latestId;

  loadDashboard({int? pageIndex}) async {
    connectionStatus = ConnectionStatus.active;
    notifyListeners();
    String url = "";

    if (dateRange != null) {
      String start = dateRange!.start.toIso8601String();
      String end = dateRange!.end.toIso8601String();

      url =
          "$baseUrl/get_alerts?page_size=$selectedPageCount&page=${pageIndex ?? 0}&filter=alert_timestamp between $start,$end";
    } else if (selectedFilterName != "") {
      url =
          "$baseUrl/get_alerts?page_size=$selectedPageCount&page=${pageIndex ?? 0}&filter=$selectedFilterTag contains $selectedFilterName";
    } else {
      url =
          "$baseUrl/get_alerts?page_size=$selectedPageCount&page=${pageIndex ?? 0}";
    }



    var res = await http.get(
      Uri.parse(url),
    );
    Map<String, dynamic> jsonRes = jsonDecode(res.body);

    if (jsonRes["status_code"] == 200) {
      dashboardModel = DashboardModel.fromJson(jsonRes);
      initialPage = pageIndex ?? 0;
      setPageSize();
      connectionStatus = ConnectionStatus.done;
      notifyListeners();
    } else {
      _constant.getToast(title: jsonRes["message"]);
      connectionStatus = ConnectionStatus.error;
      notifyListeners();
    }
  }

  initDashboardStream() async {


    Future.delayed(Duration(seconds: 2), () {
      initDashboardStream();
      fetchDashboardData();
    });
  }

  fetchDashboardData({int? pageIndex}) async {
    print("called");
    String url = "";

    if (dateRange != null) {
      String start = dateRange!.start.toIso8601String();
      String end = dateRange!.end.toIso8601String();

      url =
          "$baseUrl/get_alerts?page_size=$selectedPageCount&page=${pageIndex ?? 0}&filter=alert_timestamp between $start,$end";
    } else if (selectedFilterName != "") {
      url =
          "$baseUrl/get_alerts?page_size=$selectedPageCount&page=${pageIndex ?? 0}&filter=$selectedFilterTag contains $selectedFilterName";
    } else {
      url =
          "$baseUrl/get_alerts?page_size=$selectedPageCount&page=${pageIndex ?? 0}";
    }

    var res = await http.get(
      Uri.parse(url),
    );
    Map<String, dynamic> jsonRes = jsonDecode(res.body);

    if (jsonRes["status_code"] == 200) {
      dashboardModel = DashboardModel.fromJson(jsonRes);
      latestId = dashboardModel.data.alertData[0].id;
      initialPage = pageIndex ?? 0;
      setPageSize();
    } else {
      print(jsonRes);
      _constant.getToast(title: jsonRes["message"]);
    }
    notifyListeners();
  }

  bool isNewCard({required int id}){
    if(latestId == null){
      return false;
    }else if(latestId! < id){
      return true;
    }

    return false;
  }

  loadDashboardFilter() async {
    connectionStatus = ConnectionStatus.active;
    notifyListeners();

    var res = await http.get(
      Uri.parse("$baseUrl/side_filter"),
    );
    Map<String, dynamic> jsonRes = jsonDecode(res.body);
    if (jsonRes["status_code"] == 200) {
      dashboardFilterModel = DashboardFilterModel.fromJson(jsonRes);
      connectionStatus = ConnectionStatus.done;
      print(dashboardFilterModel.data);
      notifyListeners();
    } else {
      _constant.getToast(title: jsonRes["message"]);
      connectionStatus = ConnectionStatus.error;
      notifyListeners();
    }
  }

  applyFilter({required String filter, required String tag}) async {
    dateRange = null;
    selectedFilterName = filter;
    selectedFilterTag = tag;
    loadDashboard();
  }

  applyDateFilter({required DateTimeRange d}) {
    dateRange = d;
    selectedFilterName = "";
    selectedFilterTag = "";
    loadDashboard();
  }

  setPageSize() {
    int totalCount = 0;
    List<CountData> countDataList = dashboardModel.data.countData;
    for (int i = 0; i < countDataList.length; i++) {
      totalCount += countDataList[i].count;
    }
    totalPageCount = (totalCount / selectedPageCount).ceil();
  }

  resetFilter() {
    dateRange = null;
    selectedFilterName = "";
    loadDashboard();
  }

  setInitialPage(int pageNo) {
    initialPage = pageNo;
  }

  switchPageSize(int size) {
    selectedPageCount = size;
    loadDashboard();
    notifyListeners();
  }
}
