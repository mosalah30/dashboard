import "package:dashboard/pages/config.dart";
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path/path.dart';
import 'package:async/async.dart';

Future<bool> createData(Map arrInsert, String urlPage, BuildContext context,
    Widget Function() movePage) async {
  String url = path_api + "${urlPage}?token=" + token;

  http.Response respone = await http.post(url, body: arrInsert);
  if (json.decode(respone.body)["code"] == "200") {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => movePage()));

    print("success");
    return true;
  } else {
    print("Failer");
    return false;
  }
}

Future<bool> uploadFileWithData(File imageFile, Map arrInsert, String urlPage,
    BuildContext context, Widget Function() movePage, String type) async {
  var stream = http.ByteStream(DelegatingStream.typed(imageFile.openRead()));

  var length = await imageFile.length();
  String url = path_api + "${urlPage}?token=" + token;
  var uri = Uri.parse(url);
  print(uri.path);
  var request = new http.MultipartRequest("POST", uri);
  var multipartFile = new http.MultipartFile("file", stream, length,
      filename: basename(imageFile.path));
  for (var entry in arrInsert.entries) {
    request.fields[entry.key] = entry.value;
  }

  request.files.add(multipartFile);
  var response = await request.send();

  if (response.statusCode == 200) {
    print("Send succefull");
    if (type == "update") {
      Navigator.pop(context);
    } else if (type == "insert") {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => movePage()));
    }
    return true;
  } else {
    return false;
    print("not send");
  }
}

Future<bool> updateData(
    Map arrUpdate, String urlPage, BuildContext context) async {
  String url = path_api + "${urlPage}?token=" + token;

  http.Response respone = await http.post(url, body: arrUpdate);
  if (json.decode(respone.body)["code"] == "200") {
    Navigator.pop(context);

    print("success");
    return true;
  } else {
    print("Failer");
    return false;
  }
}

Future<List> getData(int count, String urlPage, String strSearch) async {
  String url = path_api +
      "${urlPage}?txtsearch=${strSearch}&start=${count}&end=10&token=" +
      token;
  print(url);
  http.Response respone = await http.post(url);

  if (json.decode(respone.body)["code"] == "200") {
    {
      List arr = (json.decode(respone.body)["message"]);
      print(arr);
      return arr;
    }
  }
}

Future<bool> deleteData(String col_id, String val_id, String urlPage) async {
  String url = path_api + "${urlPage}?${col_id}=${val_id}&token=" + token;
  print(url);
  http.Response respone = await http.post(url);

  if (json.decode(respone.body)["code"] == "200") {
    return true;
  } else {
    return false;
  }
}
