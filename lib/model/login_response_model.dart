

class LoginResponseModel {
  LoginResponseModel({
    required this.success,
    required this.data,
    required this.statusCode,
    required this.message,
  });
  late final bool success;
  late final Data data;
  late final int statusCode;
  late final String message;

  LoginResponseModel.fromJson(Map<String, dynamic> json){
    success = json['success'];
    data = Data.fromJson(json['data']);
    statusCode = json['status_code'];
    message = json['message'];
  }
}

class Data {
  Data({
    required this.loggedin,
    required this.user,
  });
  late final String loggedin;
  late final int user;

  Data.fromJson(Map<String, dynamic> json){
    loggedin = json['loggedin'];
    user = json['user'];
  }
}