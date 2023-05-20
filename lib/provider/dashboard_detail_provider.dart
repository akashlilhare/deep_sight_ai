

import 'package:flutter/cupertino.dart';

class DashboardDetailProvider with ChangeNotifier {
  bool isImage = true;

  switchMedia({required int idx}){
    if(idx == 0){
      isImage = true;
    }else{
      isImage = false;
    }
    notifyListeners();
  }
  downloadFile(){

  }

  shareMedia(){

  }

  shareReport(){

  }
}