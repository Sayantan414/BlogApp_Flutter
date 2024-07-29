import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:blogapp/Utils/functions.dart';

var baseUrl = getBaseUrl();
var token = getValidToken();

Future<List<dynamic>> fetchAllPost() async {
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    // 'Authorization': token
  };

  final response =
      await http.get(Uri.parse('$baseUrl/api/v1/posts'), headers: headers);

  if (response.statusCode == 200) {
    // Decode the JSON response
    Map<String, dynamic> decodedResponse = jsonDecode(response.body);
    if (decodedResponse['status'] == 'success') {
      List<dynamic> posts = decodedResponse['data'];
      return posts;
    } else {
      return Future.error(decodedResponse['message'] ?? 'An error occurred');
    }
  } else {
    return Future.error(
        jsonDecode(response.body)['message'] ?? 'An error occurred');
  }
}

Future<Map<String, dynamic>> likePost(String id) async {
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization': token
  };

  final response = await http.get(Uri.parse('$baseUrl/api/v1/posts/likes/$id'),
      headers: headers);

  if (response.statusCode == 200) {
    final String responseString = response.body;
    return jsonDecode(responseString);
  } else {
    return Future.error(jsonDecode(response.body)['message']);
  }
}
