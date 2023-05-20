class DashboardModel {
  DashboardModel({
    required this.success,
    required this.data,
    required this.statusCode,
    required this.message,
    required this.jsonData
  });
  late final bool success;
  late final Data data;
  late final int statusCode;
  late final String message;
  late final Map<String, dynamic> jsonData;

  DashboardModel.fromJson(Map<String, dynamic> json){
    success = json['success'];
    data = Data.fromJson(json['data']);
    statusCode = json['status_code'];
    message = json['message'];
    jsonData = json;
  }

}

class Data {
  Data({
    required this.alertData,
    required this.countData,
  });
  late final List<AlertData> alertData;
  late final List<CountData> countData;

  Data.fromJson(Map<String, dynamic> json){
    alertData = List.from(json['alert_data']).map((e)=>AlertData.fromJson(e)).toList();
    countData = List.from(json['count_data']).map((e)=>CountData.fromJson(e)).toList();


  }
}

class AlertData {
  AlertData({
    required this.id,
    required this.cameraName,
    this.location,
    required this.ip,
    required this.channel,
    required this.featureType,
    required this.alertTimestamp,
    required this.imagePath,
    this.videoPath,
  });
  late final int id;
  late final String cameraName;
  late final String? location;
  late final String ip;
  late final int channel;
  late final String featureType;
  late final String alertTimestamp;
  late final String imagePath;
  late final String? videoPath;

  AlertData.fromJson(Map<String, dynamic> json){
    id = json['ID'];
    cameraName = json['camera_name'];
    location = json['location'];
    ip = json['ip'];
    channel = json['channel'];
    featureType = json['feature_type'];
    alertTimestamp = json['alert_timestamp'];
    imagePath = json['image_path'];
    videoPath = json['video_path'];
  }

}

class CountData {
  CountData({
    required this.featureType,
    required this.count,
  });
  late final String featureType;
  late final int count;

  CountData.fromJson(Map<String, dynamic> json){
    featureType = json['feature_type'];
    count = json['count'];
  }


}