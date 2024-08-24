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

Future<List<dynamic>> fetchComments(String id) async {
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization': token
  };

  final response = await http
      .get(Uri.parse('$baseUrl/api/v1/posts/comments/$id'), headers: headers);
  // print(response.body);

  if (response.statusCode == 200) {
    // Decode the JSON response
    Map<String, dynamic> decodedResponse = jsonDecode(response.body);
    if (decodedResponse['status'] == 'success') {
      List<dynamic> comments = decodedResponse['data'];
      return comments;
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
    String title, String description, String category, File? imageFile) async {
  final url = Uri.parse('$baseUrl/api/v1/posts');
  final request = http.MultipartRequest('POST', url);

  // Add headers
  request.headers.addAll({
    'Content-Type': 'application/json',
    'Authorization': token // replace with your actual token
  });

  // Add fields
  request.fields['title'] = title;
  request.fields['description'] = description;
  request.fields['category'] = category;
  print(request.fields);
  // Add image file if available
  if (imageFile != null) {
    request.files.add(
      await http.MultipartFile.fromPath(
        'image',
        imageFile.path,
      ),
    );
  }

  try {
    final response = await request.send();

    // Read the response as a string
    final responseData = await http.Response.fromStream(response);
    print(responseData.body);

    if (response.statusCode == 200) {
      final data = json.decode(responseData.body);
      print('Post created: ${data['data']}');
    } else {
      print('Failed to create post: ${response.statusCode}');
      print('Response body: ${responseData.body}');
    }
  } catch (e) {
    print('Error: $e');
  }
}

Future<Map<String, dynamic>> updatePost(String title, String description,
    String category, File? imageFile, String postId) async {
  final url = Uri.parse('$baseUrl/api/v1/posts/$postId');
  final request = http.MultipartRequest('PUT', url);

  // Add headers
  request.headers.addAll({
    'Content-Type': 'application/json',
    'Authorization': token // replace with your actual token
  });

  // Add fields
  request.fields['title'] = title;
  request.fields['description'] = description;
  request.fields['category'] = category;
  print(request.fields);
  // Add image file if available
  if (imageFile != null) {
    request.files.add(
      await http.MultipartFile.fromPath(
        'image',
        imageFile.path,
      ),
    );
  }

  final response = await request.send();

  // Read the response as a string
  final responseData = await http.Response.fromStream(response);
  // print(responseData.body);

  final data = json.decode(responseData.body);
  if (response.statusCode == 200) {
    // print('Post created: ${data['data']}');
    return data['data'];
  } else {
    print('Failed to create post: ${response.statusCode}');
    return data['data'];
  }
}
