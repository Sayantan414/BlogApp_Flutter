import 'dart:convert';
import 'dart:math';

import 'package:blogapp/NetworkHandler.dart';
import 'package:blogapp/Pages/HomePage.dart';
import 'package:blogapp/Services/userService.dart';
import 'package:blogapp/Utils/functions.dart';
import "package:flutter/material.dart";

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool vis = true;
  final _globalkey = GlobalKey<FormState>();
  NetworkHandler networkHandler = NetworkHandler();
  TextEditingController _firstnameController = TextEditingController();
  TextEditingController _lastnameController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  // ignore: avoid_init_to_null
  String? errorText = null;
  bool validate = false;
  bool circular = false;
  String pic = "";

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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Register",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  color: Color(0xff00A86B),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              firstnameTextField(),
              lastnameTextField(),
              emailTextField(),
              passwordTextField(),
              const SizedBox(
                height: 20,
              ),
              InkWell(
                // onTap: () async {
                //   setState(() {
                //     circular = true;
                //   });
                //   await checkUser();
                //   if (_globalkey.currentState!.validate() && validate) {
                //     Map<String, String> data = {
                //       "firstname": _firstnameController.text,
                //       "lastname": _lastnameController.text,
                //       "email": _emailController.text,
                //       "password": _passwordController.text,
                //     };
                //     print(data);
                //     var responseRegister =
                //         await networkHandler.post("/user/register", data);

                //     if (responseRegister.statusCode == 200 ||
                //         responseRegister.statusCode == 201) {
                //       // print(responseRegister.body);

                //       Map<String, String> data = {
                //         "email": _emailController.text,
                //         "password": _passwordController.text,
                //       };
                //       var response =
                //           await networkHandler.post("/login", data);

                //       // print(response.body);

                //       if (response.statusCode == 200 ||
                //           response.statusCode == 201) {
                //         Map<String, dynamic> output =
                //             json.decode(response.body);
                //         print(output);

                //         savetoken(output["token"]);
                //         saveDp(output["dp"]);
                //         saveUsername(output["username"]);

                //         setState(() {
                //           validate = true;
                //           circular = false;
                //         });
                //         Navigator.pushAndRemoveUntil(
                //             context,
                //             MaterialPageRoute(
                //               builder: (context) => HomePage(),
                //             ),
                //             (route) => false);
                //       } else {
                //         ScaffoldMessenger.of(context).showSnackBar(
                //           const SnackBar(
                //             content: Text('Network error!'),
                //           ),
                //         );
                //       }
                //       setState(() {
                //         circular = false;
                //       });
                //     } else {
                //       setState(() {
                //         circular = false;
                //       });
                //     }
                //   }
                // },
                onTap: () async {
                  var payLoad = {
                    "firstname": _firstnameController.text,
                    "lastname": _lastnameController.text,
                    "email": _emailController.text,
                    "password": _passwordController.text,
                  };

                  try {
                    var r = await register(payLoad);

                    // print(r);

                    var payLoadLogin = {
                      "email": _emailController.text,
                      "password": _passwordController.text,
                    };

                    try {
                      var loginresponse = await login(payLoadLogin);

                      // print(loginresponse);
                      saveValidtoken(loginresponse["data"]["token"]);
                      saveUserDetails(
                          loginresponse["data"]['firstname'],
                          loginresponse["data"]['lastname'],
                          loginresponse["data"]['profilePhoto'],
                          loginresponse["data"]['email'],
                          loginresponse["data"]['id']);
                    } catch (e) {
                      print(e);
                    }
                  } catch (e) {
                    print(e);
                  }
                },
                child: circular
                    ? const CircularProgressIndicator()
                    : Container(
                        width: 150,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Color(0xff00A86B),
                            borderRadius: BorderRadius.circular(10)),
                        child: const Center(
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }

  checkUser() async {
    if (_usernameController.text.length == 0) {
      setState(() {
        // circular = false;
        validate = false;
        errorText = "Username Can't be empty";
      });
    } else {
      var response = await networkHandler
          .get("/user/checkusername/${_usernameController.text}");
      var responseData = json.decode(response);
      if (responseData['Status']) {
        setState(() {
          // circular = false;
          validate = false;
          errorText = "Username already taken";
        });
      } else {
        setState(() {
          // circular = false;
          validate = true;
        });
      }
    }
  }

  Widget firstnameTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Firstname",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 8), // Add spacing between Text and TextFormField
          TextFormField(
            controller: _firstnameController,
            decoration: InputDecoration(
              filled: true,
              fillColor: Color.fromARGB(255, 226, 241, 221),
              errorText: validate ? null : errorText,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 2),
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
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget lastnameTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Lastname",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 8), // Add spacing between Text and TextFormField
          TextFormField(
            controller: _lastnameController,
            decoration: InputDecoration(
              filled: true,
              fillColor: Color.fromARGB(255, 226, 241, 221),
              errorText: validate ? null : errorText,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 2),
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
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget emailTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Email",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 8), // Add spacing between Text and TextFormField
          TextFormField(
            controller: _emailController,
            validator: (value) {
              if (value!.isEmpty) {
                return "Email required!";
              }
              if (!value.contains("@")) {
                return "Email is Invalid";
              }
              return null;
            },
            decoration: InputDecoration(
              filled: true,
              fillColor: Color.fromARGB(255, 226, 241, 221),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 2),
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
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget passwordTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10.0),
      child: Column(
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
            validator: (value) {
              if (value!.isEmpty) {
                return "Password required!";
              }
              if (value.length < 4) {
                return "Password length must have >= 4";
              }
              return null;
            },
            obscureText: vis,
            decoration: InputDecoration(
              filled: true,
              fillColor: Color.fromARGB(255, 226, 241, 221),
              suffixIcon: IconButton(
                icon: Icon(vis ? Icons.visibility_off : Icons.visibility),
                onPressed: () {
                  setState(() {
                    vis = !vis;
                  });
                },
              ),
              helperText: "**Password length should have >= 4",
              helperStyle: TextStyle(fontSize: 14),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 2),
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
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ],
      ),
    );
  }
}
