
import 'package:flutter/material.dart';

class FeatureDataModel {
  FeatureDataModel({
    required this.success,
    required this.data,
    required this.statusCode,
    required this.message,
  });
  late final bool success;
  late final Data data;
  late final int statusCode;
  late final String message;

  FeatureDataModel.fromJson(Map<String, dynamic> json){
    success = json['success'];
    data = Data.fromJson(json['data']);
    statusCode = json['status_code'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['success'] = success;
    _data['data'] = data.toJson();
    _data['status_code'] = statusCode;
    _data['message'] = message;
    return _data;
  }
}

class Data {
  Data({
    required this.x,
    required this.y,
    required this.colors,
  });
  late final List<String?> x;
  late final List<int> y;
  late final List<Color> colors;

  Data.fromJson(Map<String, dynamic> json){
    x = List.castFrom<dynamic, String?>(json['x']);
    y = List.castFrom<dynamic, int>(json['y']);
    List<Color> c =[];
    for(int i=0; i<x.length; i++){
      c.add(colorList[i]);
    }
    colors = c;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['x'] = x;
    _data['y'] = y;
    return _data;
  }
}

List<Color> colorList = [
  Colors.red,
  Colors.green,
  Colors.blue,
  Colors.orange,
  Colors.pink,
  Colors.indigo,
  Colors.purple,
  Colors.brown,
  Colors.blue.shade700,
  Colors.red,
  Colors.green,
  Colors.blue,
  Colors.orange,
  Colors.pink,
  Colors.indigo,
  Colors.purple,
  Colors.brown,
  Colors.blue.shade700,
  Colors.red,
  Colors.green,
  Colors.blue,
  Colors.orange,
  Colors.pink,
  Colors.indigo,
  Colors.purple,
  Colors.brown,
  Colors.blue.shade700,
];