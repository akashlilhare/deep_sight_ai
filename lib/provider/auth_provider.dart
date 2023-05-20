import 'dart:convert';

import 'package:deep_sight_ai_labs/constants/constant.dart';
import 'package:deep_sight_ai_labs/enum/connection_status.dart';
import 'package:deep_sight_ai_labs/healper/sp_helper.dart';
import 'package:deep_sight_ai_labs/healper/sp_key_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../main_page.dart';
import '../model/login_response_model.dart';


String fcmToken = "";

class AuthProvider with ChangeNotifier {
  ConnectionStatus connectionStatus = ConnectionStatus.none;
  final Constant _constant = Constant();


  Future<void> login(
      {required String username,
      required String password,
      required BuildContext context}) async {
    connectionStatus = ConnectionStatus.active;
    notifyListeners();

    try {
      var postBody = {"username": username, "password": password, "fcm_token" : fcmToken };

      print(postBody);
      print("post body");

      var res = await http.post(Uri.parse("$baseUrl/login"),
          body: jsonEncode(postBody),
          headers: {"Content-Type": "application/json"});

      Map<String, dynamic> jsonRes = jsonDecode(res.body);
      if (jsonRes["status_code"] == 200) {
        LoginResponseModel loginResponseModel =
            LoginResponseModel.fromJson(jsonDecode(res.body));
        setUser(userId: loginResponseModel.data.user);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (builder) {
          return MainPage();
        }));
      } else {
        print(jsonRes);
        _constant.getToast(title: jsonRes["message"]);
      }
    } catch (e) {
      print(e);
      _constant.getToast(title: "Something went wrong");
    }
    connectionStatus = ConnectionStatus.none;
    notifyListeners();
  }


  setUser({required int userId}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(SpKeyHelper.isLogdin, true);
    await prefs.setInt(SpKeyHelper.userId, userId);
  }

  Future<bool> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    bool? isLogdin = prefs.getBool(SpKeyHelper.isLogdin);
    return isLogdin ?? false;
  }

  logout({required BuildContext context}) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    Phoenix.rebirth(context);
  }
}
