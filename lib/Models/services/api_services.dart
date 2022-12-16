import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:finwizz/constant/api_const.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../../get_storage_services/get_storage_service.dart';
import 'app_exception.dart';

enum APIType { aPost, aGet, aPut, aPatch }

class APIService {
  var response;
  // var request;

  @override
  Future getResponse(
      {required String url,
      required APIType apitype,
      Map<String, dynamic>? body,
      Map<String, String>? header,
      bool fileUpload = false}) async {
    Map<String, String> headers = GetStorageServices.getBarrierToken() != null
        ? {
            'Authorization': 'Bearer ${GetStorageServices.getBarrierToken()}',
            'Content-Type': 'application/json'
          }
        : {'Content-Type': 'application/json'};

    print("Bearer ${GetStorageServices.getBarrierToken()}");

    try {
      if (apitype == APIType.aGet) {
        final result =
            await http.get(Uri.parse(APIConst.baseUrl + url), headers: headers);
        response = returnResponse(result.statusCode, result.body);
        log("RES status code ${result.statusCode}");
        log("res${result.body}");
      } else /*if (apitype == APIType.aPost)*/ {
        print("REQUEST PARAMETER url  $url");
        print("REQUEST PARAMETER $body");

        final result = await http.post(Uri.parse(APIConst.baseUrl + url),
            body: json.encode(body), headers: headers);
        print("resp${result.body}");
        response = returnResponse(result.statusCode, result.body);
        print(result.statusCode);
      }
      /*else {
        print("REQUEST PARAMETER url  $url");
        print("REQUEST PARAMETER $body");

        final request =
            await http.MultipartRequest("PUT", Uri.parse(baseUrl + url));

        request.headers.addAll(headers);

        request.fields["name"] = body!["name"];
        request.fields["height"] = body["height"];
        request.files.add(await http.MultipartFile.fromPath(
            "userImage", body["userImage"],
            contentType: MediaType('userImage', 'jpg')));
        request.fields["age"] = body["age"];
        request.fields["weight"] = body["weight"];

        var result = await request.send();
        String res = await result.stream.transform(utf8.decoder).join();

        // print("resp${result.body}");
        response = returnResponse(result.statusCode, res);
        // print(result.statusCode);
      }*/
    } on SocketException {
      throw FetchDataException('No Internet access');
    }

    return response;
  }

  Future getPatchResponse(
      {required String url,
      required APIType apitype,
      Map<String, dynamic>? body1,
      Map<String, String>? header,
      bool fileUpload = false}) async {
    Map<String, String> headers = GetStorageServices.getBarrierToken() != null
        ? {
            'Authorization': 'Bearer ${GetStorageServices.getBarrierToken()}',
            'Content-Type': 'application/json'
          }
        : {'Content-Type': 'application/json'};

    try {
      if (apitype == APIType.aPatch) {
        log("headers ==== > ${headers}");

        final result = await http.patch(Uri.parse(APIConst.baseUrl + url),
            body: json.encode(body1), headers: headers);
        response = returnResponse(result.statusCode, result.body);
        log("RES status code ${result.statusCode}");
        log("res${result.body}");
      }
    } on SocketException {
      throw FetchDataException('No Internet access');
    }

    return response;
  }

  Future getPutResponse(
      {required String url,
      required APIType apitype,
      Map<String, dynamic>? body,
      Map<String, String>? header,
      bool fileUpload = false}) async {
    Map<String, String> headers = GetStorageServices.getBarrierToken() != null
        ? {
            'Authorization': 'Bearer ${GetStorageServices.getBarrierToken()}',
            'Content-Type': 'application/json'
          }
        : {'Content-Type': 'application/json'};
    try {
      print("REQUEST PARAMETER url  $url");
      print("REQUEST PARAMETER $body");

      final request =
          await http.MultipartRequest("PUT", Uri.parse(APIConst.baseUrl + url));

      request.headers.addAll(headers);

      request.fields["name"] = body!["name"];
      request.fields["height"] = body["height"];
      if (body["userImage"] != null && body["userImage"] != "") {
        request.files.add(await http.MultipartFile.fromPath(
            "userImage", body["userImage"],
            contentType: MediaType('userImage', 'jpg')));
      }
      request.fields["age"] = body["age"];
      request.fields["weight"] = body["weight"];

      var result = await request.send();
      String res = await result.stream.transform(utf8.decoder).join();

      // print("resp${result.body}");
      response = returnResponse(result.statusCode, res);
      // print(result.statusCode);

    } on SocketException {
      throw FetchDataException('No Internet access');
    }

    return response;
  }

  Future getPostResponse(
      {required String url,
      required APIType apitype,
      Map<String, dynamic>? body,
      Map<String, String>? header,
      bool fileUpload = false}) async {
    Map<String, String> headers = GetStorageServices.getBarrierToken() != null
        ? {
            'Authorization': 'Bearer ${GetStorageServices.getBarrierToken()}',
            'Content-Type': 'application/json'
          }
        : {'Content-Type': 'application/json'};
    try {
      print("REQUEST PARAMETER url  $url");
      print("REQUEST PARAMETER $body");

      final request = await http.MultipartRequest(
          "POST", Uri.parse(APIConst.baseUrl + url));

      request.headers.addAll(headers);

      request.fields["title"] = body!["title"];
      request.fields["description"] = body["description"];
      request.files.add(await http.MultipartFile.fromPath(
          "image", body["image"],
          contentType: MediaType('image', 'jpg')));

      var result = await request.send();
      String res = await result.stream.transform(utf8.decoder).join();

      // print("resp${result.body}");
      response = returnResponse(result.statusCode, res);
      // print(result.statusCode);

    } on SocketException {
      throw FetchDataException('No Internet access');
    }

    return response;
  }

  returnResponse(int status, String result) {
    switch (status) {
      case 200:
        return jsonDecode(result);
      case 201:
        return jsonDecode(result);
      case 400:
        return jsonDecode(result);
      // throw BadRequestException('Bad Request');
      case 401:
        throw UnauthorisedException('Unauthorised user');
      case 404:
        throw ServerException('Server Error');
      case 500:
      default:
        throw FetchDataException('Internal Server Error');
    }
  }
}
