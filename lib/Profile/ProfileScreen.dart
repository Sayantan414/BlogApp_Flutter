import 'dart:convert';

import 'package:blogapp/NetworkHandler.dart';
import 'package:blogapp/Profile/CreateProfile.dart';
import 'package:flutter/material.dart';

import 'MainProfile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool circular = false;
  NetworkHandler networkHandler = NetworkHandler();
  String dp = "";

  late Map<String, dynamic> responseData;
  @override
  void initState() {
    super.initState();
    // dp = getDp();

    // fetchData();
  }

  void fetchData() async {
    try {
      var response = await networkHandler.get("/profile/getData");
      var data = json.decode(response);
      print(data);
      if (data != null && data["data"] != null) {
        responseData = data["data"];

        setState(() {
          circular = false;
        });
      } else {
        print("Response is null or doesn't contain data");
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 225, 235, 225),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 225, 235, 225),
        elevation: 0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(
                      builder: (context) =>
                          CreateProfile(type: "Edit", data: responseData)))
                  .then((value) => setState(() {
                        if (value.runtimeType == String)
                          dp = getDp();
                        else
                          responseData = value;
                        dp = getDp();
                      }));
            },
            color: Colors.black,
          ),
        ],
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
                otherDetails("About", "test"),
                otherDetails("Name", "test"),
                otherDetails("Profession", "test"),
                otherDetails("DOB", "test"),
                const Divider(
                  thickness: 0.8,
                ),
                const SizedBox(
                  height: 20,
                ),
                // const Blogs(
                //   url: "/blogpost/getOwnBlog",
                //   type: "Own",
                // ),
              ],
            ),
    );
  }

  Widget head() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Color.fromARGB(255, 225, 235, 225),
              backgroundImage: AssetImage("assets/nouser.png"),
            ),
          ),
          Text(
            "Username",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          Text("titleLine")
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
