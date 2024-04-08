import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class NetworkHandler {
  String baseurl = "https://cerulean-mite-suit.cyclic.app/";
  var log = Logger(
    printer: PrettyPrinter(),
  );

  var logrNoStack = Logger(
    printer: PrettyPrinter(methodCount: 0),
  );

  Future get(String url) async {
    url = formatter(url);
    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200 || response.statusCode == 201) {
        log.i(response.body);
        return json.decode(response.body);
      }
      log.i(response.body);
      log.i(response.statusCode);
      return response.body; // Return the response
    } catch (e) {
      log.e("Error: $e"); // Log any error that occurs
      return null; // Return null in case of error
    }
  }

  Future<http.Response> post(String url, Map<String, String> body) async {
    url = formatter(url);
    var response = await http.post(Uri.parse(url),
        headers: {"Content-type": "application/json"}, body: json.encode(body));
    return response;
  }

  String formatter(String url) {
    return baseurl + url;
  }
}
