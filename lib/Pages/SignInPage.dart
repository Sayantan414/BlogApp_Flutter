import 'dart:convert';

import 'package:blogapp/NetworkHandler.dart';
import 'package:blogapp/Pages/HomePage.dart';
import 'package:blogapp/Pages/SignUpPage.dart';
import "package:flutter/material.dart";

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool vis = true;
  final _globalkey = GlobalKey<FormState>();
  NetworkHandler networkHandler = NetworkHandler();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String? errorText = null;
  bool validate = false;
  bool circular = false;
  // final storage = new FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // height: MediaQuery.of(context).size.height,
        // width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.white, Colors.green],
                begin: FractionalOffset(0.0, 1.0),
                end: FractionalOffset(0.0, 1.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.repeated)),
        child: Form(
          key: _globalkey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Sign In",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    color: Color.fromARGB(255, 36, 100, 39),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                usernameTextField(),
                SizedBox(
                  height: 15,
                ),
                passwordTextField(),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {},
                      child: Text(
                        "Forgot Password ?",
                        style: TextStyle(
                          color: Colors.blue[900],
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignUpPage()));
                      },
                      child: const Text(
                        "New User?",
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                InkWell(
                  onTap: () async {
                    setState(() {
                      circular = true;
                    });

                    //Login Logic start here
                    Map<String, String> data = {
                      "username": "sayan",
                      "password": "1234",
                    };
                    try {
                      var response =
                          await networkHandler.post("/user/login", data);

                      if (response.statusCode == 200 ||
                          response.statusCode == 201) {
                        Map<String, dynamic> output =
                            json.decode(response.body);
                        print(output["token"]);

                        saveToken(output["token"]);
                        // await storage.write(key: "token", value: output["token"]);
                        setState(() {
                          validate = true;
                          circular = false;
                        });
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => HomePage()),
                            ((route) => false));
                      } else {
                        String output = json.decode(response.body);
                        setState(() {
                          validate = false;
                          errorText = output;
                          circular = false;
                        });
                      }
                    } catch (e) {
                      print(e);
                    }

                    // login logic End here
                  },
                  child: Container(
                    width: 150,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xff00A86B),
                    ),
                    child: Center(
                      child: circular
                          ? const CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            )
                          : const Text(
                              "Log In",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget usernameTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Username",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8), // Add spacing between Text and TextFormField
        TextFormField(
          controller: _usernameController,
          style: TextStyle(color: Colors.black), // Set text color to black
          decoration: InputDecoration(
            hintText: "Enter your username",
            hintStyle: TextStyle(color: Colors.grey), // Set hint text color
            errorText: validate ? null : errorText,
            filled: true, // Set to true to fill the box with color
            fillColor:
                Color.fromARGB(255, 226, 241, 221), // Set box color to white
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue, width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[400]!, width: 1),
              borderRadius: BorderRadius.circular(8),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            // You can add more customizations as needed
          ),
        )
      ],
    );
  }

  Widget passwordTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Password",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 8), // Add spacing between Text and TextFormField
        TextFormField(
          controller: _passwordController,
          obscureText: vis,
          style: TextStyle(color: Colors.black), // Set text color to black
          decoration: InputDecoration(
            hintText: "Enter your password",
            hintStyle: TextStyle(color: Colors.grey),
            filled: true,
            fillColor:
                Color.fromARGB(255, 226, 241, 221), // Set hint text color
            errorText: validate ? null : errorText,
            suffixIcon: IconButton(
              icon: Icon(vis ? Icons.visibility_off : Icons.visibility),
              onPressed: () {
                setState(() {
                  vis = !vis;
                });
              },
            ),
            helperStyle: TextStyle(fontSize: 14),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue, width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[400]!, width: 1),
              borderRadius: BorderRadius.circular(8),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            // You can add more customizations as needed
          ),
        )
      ],
    );
  }
}
