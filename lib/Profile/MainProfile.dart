import 'dart:convert';

import 'package:blogapp/Blog/Blogs.dart';
import 'package:blogapp/NetworkHandler.dart';
import 'package:flutter/material.dart';

class MainProfile extends StatefulWidget {
  const MainProfile({super.key});

  @override
  _MainProfileState createState() => _MainProfileState();
}

class _MainProfileState extends State<MainProfile> {
  bool circular = true;
  NetworkHandler networkHandler = NetworkHandler();

  late Map<String, dynamic> responseData;
  @override
  void initState() {
    super.initState();
    fetchData();
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
      backgroundColor: Color.fromARGB(255, 225, 235, 225),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 225, 235, 225),
        elevation: 0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {},
            color: Colors.black,
          ),
        ],
      ),
      body: circular
          ? Center(child: CircularProgressIndicator())
          : ListView(
              children: <Widget>[
                head(),
                Divider(
                  thickness: 0.8,
                ),
                otherDetails("About", responseData['about'] ?? ""),
                otherDetails("Name", responseData['name'] ?? ""),
                otherDetails("Profession", responseData['profession'] ?? ""),
                otherDetails("DOB", responseData['DOB'] ?? ""),
                Divider(
                  thickness: 0.8,
                ),
                SizedBox(
                  height: 20,
                ),
                Blogs(
                  url: "/blogpost/getOwnBlog",
                ),
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
              backgroundImage: NetworkHandler().getImage('sayan'),
            ),
          ),
          Text(
            responseData['username'] ?? "",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          Text(responseData['titleline'] ?? "")
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
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            value,
            style: TextStyle(fontSize: 15),
          )
        ],
      ),
    );
  }
}
