import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:blogapp/Utils/functions.dart';

var baseUrl = getBaseUrl();

Future<Map<String, dynamic>> register(Map<String, dynamic> payload) async {
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    // 'Authorization': '$token'
  };

  final response = await http.post(Uri.parse('$baseUrl/api/v1/users/register'),
      body: jsonEncode(payload), headers: headers);
  if (response.statusCode == 200) {
    final String responseString = response.body;
    return jsonDecode(responseString);
  } else {
    // print(jsonDecode(response.body)['error']);
    return Future.error(jsonDecode(response.body)['message']);
  }
}

Future<Map<String, dynamic>> login(Map<String, dynamic> payload) async {
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    // 'Authorization': '$token'
  };

  final response = await http.post(Uri.parse('$baseUrl/api/v1/users/login'),
      body: jsonEncode(payload), headers: headers);
  if (response.statusCode == 200) {
    final String responseString = response.body;
    return jsonDecode(responseString);
  } else {
    // print(jsonDecode(response.body)['error']);
    return Future.error(jsonDecode(response.body)['message']);
  }
}
