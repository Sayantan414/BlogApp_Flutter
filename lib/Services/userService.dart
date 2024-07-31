import 'dart:math';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:blogapp/Utils/functions.dart';

var baseUrl = getBaseUrl();
var token = getValidToken();

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

Future<Map<String, dynamic>> profile() async {
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization': token
  };

  final response = await http.get(Uri.parse('$baseUrl/api/v1/users/profile'),
      headers: headers);

  if (response.statusCode == 200) {
    // Decode the JSON response
    Map<String, dynamic> decodedResponse = jsonDecode(response.body);
    if (decodedResponse['status'] == 'success') {
      Map<String, dynamic> profileDetails = decodedResponse['data'];
      return profileDetails;
    } else {
      return Future.error(decodedResponse['message'] ?? 'An error occurred');
    }
  } else {
    print("object");
    return Future.error(
        jsonDecode(response.body)['message'] ?? 'An error occurred');
  }
}

Future<Map<String, dynamic>> following(String id) async {
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization': token
  };

  final response = await http
      .get(Uri.parse('$baseUrl/api/v1/users/following/$id'), headers: headers);

  if (response.statusCode == 200) {
    final String responseString = response.body;
    return jsonDecode(responseString);
  } else {
    return Future.error(jsonDecode(response.body)['message']);
  }
}

Future<Map<String, dynamic>> unfollow(String id) async {
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization': token
  };

  final response = await http
      .get(Uri.parse('$baseUrl/api/v1/users/unfollow/$id'), headers: headers);

  if (response.statusCode == 200) {
    final String responseString = response.body;
    return jsonDecode(responseString);
  } else {
    return Future.error(jsonDecode(response.body)['message']);
  }
}
