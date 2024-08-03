import 'dart:io';

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

Future<Map<String, dynamic>> dislikePost(String id) async {
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization': token
  };

  final response = await http
      .get(Uri.parse('$baseUrl/api/v1/posts/dislikes/$id'), headers: headers);

  if (response.statusCode == 200) {
    final String responseString = response.body;
    return jsonDecode(responseString);
  } else {
    return Future.error(jsonDecode(response.body)['message']);
  }
}

Future<Map<String, dynamic>> viewPost(String id) async {
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization': token
  };

  final response = await http
      .get(Uri.parse('$baseUrl/api/v1/posts/numViews/$id'), headers: headers);

  if (response.statusCode == 200) {
    final String responseString = response.body;
    return jsonDecode(responseString);
  } else {
    return Future.error(jsonDecode(response.body)['message']);
  }
}

Future<void> createPost(
    String title, String description, String category, File? image) async {
  final url = Uri.parse('$baseUrl/api/v1/posts'); // Replace with your API URL
  final headers = {
    'Content-Type': 'multipart/form-data',
    'Authorization': 'Bearer YOUR_TOKEN', // Include the token if required
  };

  var request = http.MultipartRequest('POST', url)
    ..fields['title'] = title
    ..fields['description'] = description
    ..fields['category'] = category
    ..headers.addAll(headers);

  if (image != null) {
    request.files.add(await http.MultipartFile.fromPath('image', image.path));
  }

  try {
    final response = await request.send();
    if (response.statusCode == 200) {
      final responseData = await http.Response.fromStream(response);
      final data = jsonDecode(responseData.body);
      print('Post created: $data');
    } else {
      print('Failed to create post: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }
}
