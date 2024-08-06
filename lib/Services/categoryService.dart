import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:blogapp/Utils/functions.dart';

var baseUrl = getBaseUrl();
var token = getValidToken();

Future<List<dynamic>> fetchAllCategory() async {
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    // 'Authorization': token
  };

  final response =
      await http.get(Uri.parse('$baseUrl/api/v1/categories'), headers: headers);

  if (response.statusCode == 200) {
    // Decode the JSON response
    Map<String, dynamic> decodedResponse = jsonDecode(response.body);
    if (decodedResponse['status'] == 'success') {
      List<dynamic> categories = decodedResponse['data'];
      print(categories);
      return categories;
    } else {
      return Future.error(decodedResponse['message'] ?? 'An error occurred');
    }
  } else {
    return Future.error(
        jsonDecode(response.body)['message'] ?? 'An error occurred');
  }
}
