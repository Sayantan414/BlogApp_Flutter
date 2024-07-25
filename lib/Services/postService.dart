import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:blogapp/Utils/functions.dart';

var baseUrl = getBaseUrl();

Future<Map<String, dynamic>> fetchAllPost() async {
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    // 'Authorization': token
  };

  final response =
      await http.get(Uri.parse('$baseUrl/api/v1/posts'), headers: headers);

  if (response.statusCode == 200) {
    final String responseString = response.body;

    return jsonDecode(responseString);
  } else {
    // print(jsonDecode(response.body)['error']);
    return Future.error(jsonDecode(response.body)['error']);
  }
}
