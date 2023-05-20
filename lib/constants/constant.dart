import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

String baseUrl = "http://122.176.86.171:8000";

class Constant {
  var boxDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.all(Radius.circular(8)),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.5),
        blurRadius: 3,
        offset: Offset(2, 2), // changes position of shadow
      ),
    ],
  );

  getDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Container(
        height: 1,
        width: double.infinity,
        color: Colors.grey.withOpacity(.15),
      ),
    );
  }

  openLink({required String url}) async {
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }

  getToast({required String title}) {
    Fluttertoast.showToast(
        msg: title,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        fontSize: 16.0);
  }

  String getFormattedTitle({required String title}) {
    String newTitle = "";
    List<String> titleList = title.split("_");
    for (String t in titleList) {
      String formattedTitle = t[0].toUpperCase() + t.substring(1, t.length);
      newTitle = "$newTitle$formattedTitle ";
    }
    return newTitle;
  }

  String getFormattedTime({required DateTime time}){
  return  DateFormat.yMEd()
        .add_jm()
        .format(time).substring(4);
  }
}
