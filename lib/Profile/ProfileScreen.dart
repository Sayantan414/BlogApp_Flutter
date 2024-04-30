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
  NetworkHandler networkHandler = NetworkHandler();
  Widget page = const CircularProgressIndicator(
      value: null, valueColor: AlwaysStoppedAnimation<Color>(Colors.green));
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkProfile();
  }

  void checkProfile() async {
    try {
      var response = await networkHandler.get("/profile/checkProfile");
      print("data" + response);
      var responseData = json.decode(response);
      bool status = responseData["status"];
      print(status);
      if (status == true) {
        setState(() {
          page = MainProfile();
        });
      } else {
        setState(() {
          page = button();
        });
      }
    } catch (e) {
      setState(() {
        page = button();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(98, 197, 222, 184),
      body: Padding(
        padding: const EdgeInsets.all(2),
        child: page,
      ),
    );
  }

  Widget showProfile() {
    return const Center(child: Text("Profile Data is Avalable"));
  }

  Widget button() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 70),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const Text(
            "Tap the button to add profile data",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color.fromARGB(255, 13, 149, 61),
              fontSize: 18,
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          InkWell(
            onTap: () => {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          CreateProfile(type: "Add", data: const {})))
            },
            child: Container(
              height: 60,
              width: 150,
              decoration: BoxDecoration(
                color: Colors.blueGrey,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Center(
                child: Text(
                  "Add Profile",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
