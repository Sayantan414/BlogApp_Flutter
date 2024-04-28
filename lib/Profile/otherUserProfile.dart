import 'dart:convert';

import 'package:blogapp/NetworkHandler.dart';
import 'package:flutter/material.dart';

class OtherUserProfile extends StatefulWidget {
  const OtherUserProfile({super.key, required this.username, required this.dp});

  final String username;
  final String dp;

  @override
  _OtherUserProfileState createState() => _OtherUserProfileState();
}

class _OtherUserProfileState extends State<OtherUserProfile> {
  bool circular = true;
  bool showDetails = false;

  NetworkHandler networkHandler = NetworkHandler();

  late Map<String, dynamic> responseData;
  @override
  void initState() {
    super.initState();

    fetchData();
  }

  void fetchData() async {
    try {
      var response = await networkHandler.get("/profile/${widget.username}");
      var data = json.decode(response);
      print(data);
      if (data != null && data["data"] != null) {
        responseData = data["data"];

        setState(() {
          showDetails = true;
          circular = false;
        });
      } else {
        print("Response is null or doesn't contain data");
      }
    } catch (e) {
      setState(() {
        showDetails = false;
        circular = false;
      });
      print("Error fetching data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 216, 234, 206),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 147, 222, 151),
        title: const Text(
          'Profile',
          textAlign: TextAlign.center, // Align text at the center
        ),
        centerTitle: true, // Center the title text
      ),
      body: circular
          ? const Center(
              child: CircularProgressIndicator(
              value: null,
              valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.green), // Color of the progress indicator
            ))
          : ListView(
              children: <Widget>[
                head(),
                Divider(
                  thickness: 0.8,
                ),
                if (!showDetails)
                  Center(
                    child: Text("This user has not added his/her profile yet"),
                  ),
                if (showDetails)
                  otherDetails("About", responseData['about'] ?? ""),
                if (showDetails)
                  otherDetails("Name", responseData['name'] ?? ""),
                if (showDetails)
                  otherDetails("Profession", responseData['profession'] ?? ""),
                if (showDetails) otherDetails("DOB", responseData['DOB'] ?? ""),
                const Divider(
                  thickness: 0.8,
                ),
              ],
            ),
    );
  }

  Widget head() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Color.fromARGB(255, 225, 235, 225),
              backgroundImage: AssetImage("assets/${widget.dp}"),
            ),
          ),
          Center(
            child: Text(
              widget.username,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          if (showDetails) Center(child: Text(responseData['titleline'] ?? ""))
        ],
      ),
    );
  }

  Widget otherDetails(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "$label :",
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 15),
          )
        ],
      ),
    );
  }
}
