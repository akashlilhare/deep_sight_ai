class DashboardFilterModel {
  DashboardFilterModel({
    required this.success,
    required this.data,
    required this.statusCode,
    required this.message,
  });
  late final bool success;
  late final List<Data> data;
  late final int statusCode;
  late final String message;

  DashboardFilterModel.fromJson(Map<String, dynamic> json){
    success = json['success'];
    data = List.from(json['data']).map((e)=>Data.fromJson(e)).toList();
    statusCode = json['status_code'];
    message = json['message'];
  }
}

class Data {
  Data({
    required this.title,
    required this.values,
  });
  late final String title;
  late final List<String> values;

  Data.fromJson(Map<String, dynamic> json){
    title = json['title'];
    values = List.castFrom<dynamic, String>(json['values']);
  }
}