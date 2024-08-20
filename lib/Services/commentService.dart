import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:blogapp/Utils/functions.dart';

var baseUrl = getBaseUrl();
var token = getValidToken();

Future<Map<String, dynamic>> createComment(Map<String, dynamic> payload) async {
  final url = Uri.parse(
      '$baseUrl/api/v1/comments/${payload['id']}'); // Replace with your endpoint
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization': token, // Add token if needed
  };

  final response = await http.post(
    url,
    headers: headers,
    body: jsonEncode({
      'description': payload['description'],
    }),
  );
  if (response.statusCode == 200 || response.statusCode == 201) {
    return jsonDecode(response.body);
  } else {
    return Future.error('Failed to create comment: ${response.reasonPhrase}');
  }
}

Future<Map<String, dynamic>> updateComment(Map<String, dynamic> payload) async {
  final url = Uri.parse(
      '$baseUrl/api/v1/comments/${payload['id']}'); // Replace with your endpoint
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization': token, // Add token if needed
  };

  final response = await http.put(
    url,
    headers: headers,
    body: jsonEncode({
      'description': payload['description'],
    }),
  );
  if (response.statusCode == 200 || response.statusCode == 201) {
    return jsonDecode(response.body);
  } else {
    return Future.error('Failed to Update comment: ${response.reasonPhrase}');
  }
}

Future<String> deleteComment(String id) async {
  try {
    final response = await http.delete(
      Uri.parse('$baseUrl/api/v1/comments/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': token, // Assuming Bearer Token
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data'];
    } else if (response.statusCode == 403) {
      throw Exception("You are not allowed to delete this comment");
    } else {
      throw Exception("Failed to delete comment: ${response.statusCode}");
    }
  } catch (e) {
    print("Error: $e");
    throw e; // Rethrow the exception to be handled elsewhere
  }
}
