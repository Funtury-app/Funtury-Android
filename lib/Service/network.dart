import "dart:async";
import "dart:io";
import "package:flutter/material.dart";
import "package:funtury/Service/Path/http_protocol.dart";
import "package:http/http.dart" as http;
import "dart:convert";

class Network {
  static const baseUrl = "4ec3-2401-e180-8d53-5c9e-4401-bb20-a058-3a2c.ngrok-free.app";
  static Network manager = Network();

  Future<Map> sendRequest({
    required RequestMethod method,
    required HttpPath path,
    Map<dynamic, dynamic>? data,
    List<String> pathMid = const [],
  }) async {
    //Http requst base info
    var finalPath = path.getPath;
    for (int i = 0; i < pathMid.length; i++) {
      finalPath = finalPath.replaceFirst("%$i", pathMid[i]);
    }

    final url = Uri.https(baseUrl, finalPath);
    final headers = {"Content-Type": "application/json"};
    final body = jsonEncode(data);

    dynamic response;

    //Get request
    try {
      switch (method) {
        case RequestMethod.get:
          response = await http.get(url, headers: headers);
        case RequestMethod.post:
          response = await http.post(url, headers: headers, body: body);
        case RequestMethod.delete:
          response = await http.delete(url, headers: headers, body: body);
      }
    } on TimeoutException catch (e) {
      debugPrint("TimeoutException: $e");
      return {
        "status": "error",
        "data": {"message": "Timeout Error"}
      };
    } on SocketException catch (e) {
      debugPrint("SocketException: $e");
      return {
        "status": "error",
        "data": {"message": "Connection Error"}
      };
    } on HandshakeException catch (e) {
      debugPrint("HandshakeException: $e");
      return {
        "status": "error",
        "data": {"message": "Connection Error"}
      };
    } on http.ClientException catch (e){
      debugPrint("ClientException: $e");
      return {
        "status" : "error",
        "data" : {"message" : "Connection Error"}
      };
    }
    on Error catch (e) {
      debugPrint("Error: $e");
      return {
        "status": "error",
        "data": {"message": "Error"}
      };
    } catch (e){
      debugPrint("Error: $e");
      return {
        "status": "error",
        "data": {"message": "Error"}
      };
    }

    if (response.statusCode == 201 || response.statusCode == 200) {
      debugPrint("Response Status Code: ${response.statusCode}");
      return {
        "status": "success",
        "status_code": response.statusCode,
        "data": jsonDecode(utf8.decode(response.bodyBytes))
      };
    } else {
      debugPrint("Response Status Code: ${response.statusCode}");
      return {
        "status": "faild",
        "status_code": response.statusCode,
        "data": jsonDecode(utf8.decode(response.bodyBytes))
      };
    }
  }
}

enum RequestMethod {
  get,
  post,
  delete;
}
