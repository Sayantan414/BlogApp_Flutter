import 'dart:io';

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

Future<Map<String, dynamic>> updateUser(Map<String, dynamic> payload) async {
  final url = Uri.parse('$baseUrl/api/v1/users'); // Replace with your endpoint
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization': token, // Add token if needed
  };

  final response = await http.put(
    url,
    headers: headers,
    body: jsonEncode(payload),
  );
  if (response.statusCode == 200 || response.statusCode == 201) {
    return jsonDecode(response.body);
  } else {
    return Future.error('Failed to Update user: ${response.reasonPhrase}');
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

Future<Map<String, dynamic>> uploadProfilePhoto(File? imageFile) async {
  final url = Uri.parse('$baseUrl/api/v1/users/profile-photo-upload');
  final request = http.MultipartRequest('POST', url);

  // Add headers
  request.headers.addAll({
    'Content-Type': 'application/json',
    'Authorization': token // replace with your actual token
  });

  // Add image file if available
  if (imageFile != null) {
    request.files.add(
      await http.MultipartFile.fromPath(
        'profile',
        imageFile.path,
      ),
    );
  }

  try {
    final response = await request.send();

    // Read the response as a string
    final responseData = await http.Response.fromStream(response);
    print(responseData.body);

    return jsonDecode(responseData.body);
  } catch (e) {
    print('Error: $e');
    return Future.error(jsonDecode("An error occurred. Please try again."));
  }
}
