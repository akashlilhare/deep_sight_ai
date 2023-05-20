import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';

class FileDownloadService {
  Future downloadFile(
      {required url,
      Map<String, dynamic>? postBody,
      Map<String, dynamic>? headers,
      required String name}) async {
    print(postBody);

    final file = await downloadDoc(
        url: url, name: name, postBody: postBody, headers: headers);

    if (file == null) return;
try{
  OpenFile.open(file.path);
}catch(e){
  print(e);
}

  }

  Future<File?> downloadDoc({
    required String url,
    Map<String, dynamic>? postBody,
    Map<String, dynamic>? headers,
    required String name,
  }) async {
    try {
      final appStorage = await getApplicationDocumentsDirectory();
      final file = File("${appStorage.path}/$name");
      var options = Options(
        headers: headers ?? {},
        responseType: ResponseType.bytes,
        followRedirects: false,
       // receiveTimeout: 0,
      );
      final Response response;

      if (postBody == null) {
        response = await Dio().get(url, options: options);
      } else {
        response = await Dio().post(url, data: postBody, options: options);
      }

      final raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      await raf.close();

      return file;
    } catch (e) {

      throw "something went wrong";
    }
  }


  Future<String> downloadMedia(String url, String fileName, String dir) async {
    HttpClient httpClient = HttpClient();
    File file;
    String filePath = '';
    String myUrl = '';

    try {
      myUrl = '$url/$fileName';
      var request = await httpClient.getUrl(Uri.parse(myUrl));
      var response = await request.close();
      if(response.statusCode == 200) {
        var bytes = await consolidateHttpClientResponseBytes(response);
        filePath = '$dir/$fileName';
        file = File(filePath);
        await file.writeAsBytes(bytes);
      }
      else {
        filePath = 'Error code: ${response.statusCode}';
      }
    }
    catch(ex){
      filePath = 'Can not fetch url';
    }

    return filePath;
  }
}
