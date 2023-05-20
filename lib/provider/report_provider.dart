import 'dart:convert';

import 'package:deep_sight_ai_labs/model/feature_filter_model.dart' as ffm;
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../constants/constant.dart';
import '../enum/connection_status.dart';
import '../model/feature_data_model.dart' as fdm;

class ReportProvider with ChangeNotifier {
   ffm.FeatureFilterModel? featureFilterModel;
   ffm.FeatureFilterModel? cameraFilterModel;
  ConnectionStatus filterConnectionStatus = ConnectionStatus.none;
  ConnectionStatus cameraConnectionStatus = ConnectionStatus.none;
  final Constant _constant = Constant();
   fdm.FeatureDataModel? featureDataModel;
   fdm.FeatureDataModel? cameraDataModel;

  initFeatureData() async {
    await loadFeatureFilter();
    await loadFeatureData();
    await loadCameraFilter();
    await loadCameraData();
  }

  loadFeatureFilter() async {
    filterConnectionStatus = ConnectionStatus.active;
    notifyListeners();
    var res = await http.get(
      Uri.parse("$baseUrl/analytic_params?analytic=feature-alerts"),
    );

    Map<String, dynamic> jsonRes = jsonDecode(res.body);

    if (jsonRes["status_code"] == 200) {
      featureFilterModel =
          ffm.FeatureFilterModel.fromJson(jsonDecode(res.body));
    } else {
      _constant.getToast(title: "Something went wrong");
      filterConnectionStatus = ConnectionStatus.error;

    }

    filterConnectionStatus = ConnectionStatus.done;
    notifyListeners();
  }

  loadFeatureData() async {
    String prams = getFeaturePrams();
    final Constant _constant = Constant();

    filterConnectionStatus = ConnectionStatus.active;
    notifyListeners();
    String url = "$baseUrl/analytics?analytic=feature-alerts&$prams";

    print(url);
    print("url for feature graph");

    var res = await http.get(
      Uri.parse(url),
    );

    Map<String, dynamic> jsonRes = jsonDecode(res.body);

    if (jsonRes["status_code"] == 200) {
      featureDataModel = fdm.FeatureDataModel.fromJson(jsonDecode(res.body));
      print(featureDataModel!.data.x);
    } else {
      _constant.getToast(title: "Something went wrong");
      filterConnectionStatus = ConnectionStatus.error;
      notifyListeners();
    }

    filterConnectionStatus = ConnectionStatus.done;
    notifyListeners();
  }

  loadCameraFilter() async {
    cameraConnectionStatus = ConnectionStatus.active;
    notifyListeners();
    var res = await http.get(
      Uri.parse("$baseUrl/analytic_params?analytic=camera-alerts"),
    );

    Map<String, dynamic> jsonRes = jsonDecode(res.body);

    if (jsonRes["status_code"] == 200) {
      cameraFilterModel = ffm.FeatureFilterModel.fromJson(jsonDecode(res.body));
    } else {
      _constant.getToast(title: "Something went wrong");
      cameraConnectionStatus = ConnectionStatus.error;
      notifyListeners();
    }

    cameraConnectionStatus = ConnectionStatus.done;
    notifyListeners();
  }

  loadCameraData() async {
    String prams = getCameraPrams();
    final Constant _constant = Constant();

    cameraConnectionStatus = ConnectionStatus.active;
    notifyListeners();
    String url =
        //"http://122.176.86.171:8000/analytics?analytic=camera-alerts&days=7&site=Site-1&feature=multiple_person";
        "$baseUrl/analytics?analytic=camera-alerts&$prams";

    print(url);
    print("url for camera graph");

    var res = await http.get(
      Uri.parse(url),
    );

    print("json response");
    print(res.body);
    Map<String, dynamic> jsonRes = jsonDecode(res.body);

    print(jsonRes);

    if (jsonRes["status_code"] == 200) {
      cameraDataModel = fdm.FeatureDataModel.fromJson(jsonDecode(res.body));
      print(cameraDataModel!.data.x);
    } else {
      _constant.getToast(title: "Something went wrong");
      cameraConnectionStatus = ConnectionStatus.error;
      notifyListeners();
    }

    cameraConnectionStatus = ConnectionStatus.done;
    notifyListeners();
  }

  switchFeatureFilter({required int filterIdx, required int filterValueIdx}) {
    List<ffm.Data> updatedList = featureFilterModel!.data;
    updatedList[filterIdx] = ffm.Data(
        title: updatedList[filterIdx].title,
        values: updatedList[filterIdx].values,
        selectedId: filterValueIdx);
    featureFilterModel = ffm.FeatureFilterModel(
        success: featureFilterModel!.success,
        data: updatedList,
        statusCode: featureFilterModel!.statusCode,
        message: featureFilterModel!.message);

    loadFeatureData();
    notifyListeners();
  }

  switchCameraFilter({required int filterIdx, required int filterValueIdx}) {
    List<ffm.Data> updatedList = cameraFilterModel!.data;
    updatedList[filterIdx] = ffm.Data(
        title: updatedList[filterIdx].title,
        values: updatedList[filterIdx].values,
        selectedId: filterValueIdx);
    cameraFilterModel = ffm.FeatureFilterModel(
        success: cameraFilterModel!.success,
        data: updatedList,
        statusCode: cameraFilterModel!.statusCode,
        message: cameraFilterModel!.message);
    loadCameraData();
    notifyListeners();
  }

  String getFeaturePrams() {
    String prams = "";
    for (int i = 0; i < featureFilterModel!.data.length; i++) {
      String s = "";
      if (featureFilterModel!.data[i].title == "days") {
        int v = int.parse(featureFilterModel
            !.data[i].values[featureFilterModel!.data[i].selectedId]
            .split(" ")[0]);
        s = "${featureFilterModel!.data[i].title}=$v";
      } else {
        s = "${featureFilterModel!.data[i].title}=${featureFilterModel!.data[i].values[featureFilterModel!.data[i].selectedId]}";
      }
      if (i < featureFilterModel!.data.length - 1) {
        s += "&";
      }
      prams = prams + s;
    }
    print(prams);
    return prams;
  }

  String getCameraPrams() {
    String prams = "";
    for (int i = 0; i < cameraFilterModel!.data.length; i++) {
      String s = "";
      if (cameraFilterModel!.data[i].title == "days") {
        int v = int.parse(cameraFilterModel
            !.data[i].values[cameraFilterModel!.data[i].selectedId]
            .split(" ")[0]);
        s = "${cameraFilterModel!.data[i].title}=$v";
      } else {
        s = "${cameraFilterModel!.data[i].title}=${cameraFilterModel!.data[i].values[cameraFilterModel!.data[i].selectedId]}";
      }
      if (i < cameraFilterModel!.data.length - 1) {
        s += "&";
      }
      prams = prams + s;
    }
    print(prams);
    return prams;
  }
}
