import 'dart:convert';

import 'package:blogapp/NetworkHandler.dart';
import 'package:blogapp/Pages/HomePage.dart';
import 'package:blogapp/Pages/SignUpPage.dart';
import 'package:blogapp/Services/userService.dart';
import 'package:blogapp/Utils/colors.dart';
import 'package:blogapp/Utils/functions.dart';
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
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String? errorText = null;
  bool validate = false;
  bool circular = false;
  String pic = "";
  // final storage = new FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // height: MediaQuery.of(context).size.height,
        // width: MediaQuery.of(context).size.width,
        // decoration: BoxDecoration(
        //     gradient: LinearGradient(
        //         colors: [
        //           colorTheme(context)['primary'],
        //           colorTheme(context)['tertiary'],
        //         ],
        //         begin: FractionalOffset(0.0, 1.0),
        //         end: FractionalOffset(0.0, 1.0),
        //         stops: [0.0, 1.0],
        //         tileMode: TileMode.repeated)),
        color: colorTheme(context)['secondary'],
        child: Form(
          key: _globalkey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Sign In",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    color: colorTheme(context)['text'],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                emailTextField(),
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

                    var payLoadLogin = {
                      // "email": _emailController.text,
                      // "password": _passwordController.text,
                      "email": "deep@gmail.com",
                      "password": "12345"
                    };
                    try {
                      var loginresponse = await login(payLoadLogin);

                      // print(loginresponse);
                      saveValidtoken(loginresponse["data"]["token"]);
                      saveUserDetails(loginresponse["data"]["details"]);

                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()),
                          ((route) => false));
                    } catch (e) {
                      validate = false;
                      circular = false;
                      print(e);
                    }

                    // login logic End here
                  },
                  child: Container(
                    width: 150,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: colorTheme(context)['button'],
                    ),
                    child: Center(
                      child: circular
                          ? CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                colorTheme(context)['loader'],
                              ),
                            )
                          : Text(
                              "Log In",
                              style: TextStyle(
                                color: colorTheme(context)['buttonText'],
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

  Widget emailTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Email",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: colorTheme(context)['text'],
          ),
        ),
        const SizedBox(height: 8), // Add spacing between Text and TextFormField
        TextFormField(
          controller: _emailController,
          style: TextStyle(color: Colors.black), // Set text color to black
          decoration: InputDecoration(
            hintText: "Enter your email",
            hintStyle: TextStyle(
              color: colorTheme(context)['text'],
            ), // Set hint text color
            errorText: validate ? null : errorText,
            filled: true, // Set to true to fill the box with color
            fillColor:
                colorTheme(context)['fillColor'], // Set box color to white
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
        Text(
          "Password",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: colorTheme(context)['text'],
          ),
        ),
        SizedBox(height: 8), // Add spacing between Text and TextFormField
        TextFormField(
          controller: _passwordController,
          obscureText: vis,
          style: TextStyle(color: Colors.black), // Set text color to black
          decoration: InputDecoration(
            hintText: "Enter your password",
            hintStyle: TextStyle(
              color: colorTheme(context)['text'],
            ),
            filled: true,
            fillColor: colorTheme(context)['fillColor'], // Set hint text color
            errorText: validate ? null : errorText,
            suffixIcon: IconButton(
              icon: Icon(vis ? Icons.visibility_off : Icons.visibility),
              color: colorTheme(context)['tertiary'],
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
