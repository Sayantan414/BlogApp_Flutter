// import 'dart:io';

import 'dart:convert';

import 'package:blogapp/NetworkHandler.dart';
import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';

class CreateProfile extends StatefulWidget {
  const CreateProfile({super.key, required this.type});

  final String type;

  @override
  _CreateProfileState createState() => _CreateProfileState();
}

class _CreateProfileState extends State<CreateProfile> {
  final networkHandler = NetworkHandler();
  bool circular = false;

  final _globalkey = GlobalKey<FormState>();
  TextEditingController _name = TextEditingController();
  TextEditingController _profession = TextEditingController();
  TextEditingController _dob = TextEditingController();
  TextEditingController _titleline = TextEditingController();
  TextEditingController _about = TextEditingController();
  // final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(236, 211, 238, 196),
        elevation: 0,
        leading: IconButton(
            icon: const Icon(
              Icons.clear,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.of(context).pop("pic");
            }),
      ),
      backgroundColor: Color.fromARGB(236, 211, 238, 196),
      body: Form(
        key: _globalkey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          children: <Widget>[
            imageProfile(),
            const SizedBox(
              height: 20,
            ),
            firstnameTextField(),
            const SizedBox(
              height: 30,
            ),
            lastnameTextField(),
            const SizedBox(
              height: 30,
            ),
            emailTextField(),
            const SizedBox(
              height: 30,
            ),
            passwordTextField(),
            const SizedBox(
              height: 30,
            ),
            conPasswordTextField(),
            const SizedBox(
              height: 30,
            ),
            InkWell(
              onTap: () async {
                setState(() {
                  circular = true;
                });
                if (_globalkey.currentState!.validate()) {
                  Map<String, String> data = {
                    "name": _name.text,
                    "profession": _profession.text,
                    "DOB": _dob.text,
                    "titleline": _titleline.text,
                    "about": _about.text,
                  };
                  // var response = await networkHandler.put(
                  //     "/profile/update/${widget.data["_id"]}", data);

                  // if (response.statusCode == 200 ||
                  //     response.statusCode == 201) {
                  //   var responseData = json.decode(response.body);
                  //   print(responseData['data']);
                  //   setState(() {
                  //     circular = false;
                  //   });
                  //   Navigator.of(context).pop(responseData['data']);
                  //   // }
                  // }
                }
              },
              child: Center(
                child: Container(
                  width: 200,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: circular
                        ? const CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                        : const Text(
                            "Update",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget imageProfile() {
    return Center(
      child: Stack(
        children: <Widget>[
          CircleAvatar(
            radius: 80.0,
            backgroundColor: Color.fromARGB(236, 211, 238, 196),
            backgroundImage: AssetImage('assets/nouser.png'),
            // child: picFlag
            //     ? const CircularProgressIndicator(
            //         valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
            //       )
            //     : null,
          ),
          Positioned(
            bottom: 20.0,
            right: 20.0,
            child: InkWell(
              onTap: () {},
              child: const Icon(
                Icons.camera_alt,
                color: Colors.teal,
                size: 28.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget firstnameTextField() {
    return TextFormField(
      controller: _name,
      validator: (value) {
        if (value!.isEmpty) return "Firstname can't be empty";

        return null;
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 232, 250, 222), // Custom border color
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: Colors
                .green, // Change this to your desired color for focused state
            width: 2,
          ),
        ),
        prefixIcon: const Icon(
          Icons.person,
          color: Colors.green,
        ),
        labelText: "Firstname",
        labelStyle: TextStyle(color: Colors.black),
        hintText: "Enter your firstname",
        hintStyle: TextStyle(color: Colors.grey),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.red, width: 1),
        ),
        errorStyle: TextStyle(color: Colors.red),
      ),
    );
  }

  Widget lastnameTextField() {
    return TextFormField(
      controller: _name,
      validator: (value) {
        if (value!.isEmpty) return "lastname can't be empty";

        return null;
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 232, 250, 222), // Custom border color
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: Colors
                .green, // Change this to your desired color for focused state
            width: 2,
          ),
        ),
        prefixIcon: const Icon(
          Icons.person,
          color: Colors.green,
        ),
        labelText: "Lastname",
        labelStyle: TextStyle(color: Colors.black),
        hintText: "Enter your lastname",
        hintStyle: TextStyle(color: Colors.grey),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.red, width: 1),
        ),
        errorStyle: TextStyle(color: Colors.red),
      ),
    );
  }

  Widget emailTextField() {
    return TextFormField(
      controller: _name,
      validator: (value) {
        if (value!.isEmpty) return "email can't be empty";

        return null;
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 232, 250, 222), // Custom border color
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: Colors
                .green, // Change this to your desired color for focused state
            width: 2,
          ),
        ),
        prefixIcon: const Icon(
          Icons.email_outlined,
          color: Colors.green,
        ),
        labelText: "Email",
        labelStyle: TextStyle(color: Colors.black),
        hintText: "Enter your email",
        hintStyle: TextStyle(color: Colors.grey),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.red, width: 1),
        ),
        errorStyle: TextStyle(color: Colors.red),
      ),
    );
  }

  Widget passwordTextField() {
    return TextFormField(
      controller: _name,
      validator: (value) {
        if (value!.isEmpty) return "password can't be empty";

        return null;
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 232, 250, 222), // Custom border color
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: Colors
                .green, // Change this to your desired color for focused state
            width: 2,
          ),
        ),
        prefixIcon: const Icon(
          Icons.password,
          color: Colors.green,
        ),
        labelText: "Password",
        labelStyle: TextStyle(color: Colors.black),
        hintText: "Enter pasword",
        hintStyle: TextStyle(color: Colors.grey),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.red, width: 1),
        ),
        errorStyle: TextStyle(color: Colors.red),
      ),
    );
  }

  Widget conPasswordTextField() {
    return TextFormField(
      controller: _name,
      validator: (value) {
        if (value!.isEmpty) return "confirm your password";

        return null;
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 232, 250, 222), // Custom border color
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: Colors
                .green, // Change this to your desired color for focused state
            width: 2,
          ),
        ),
        prefixIcon: const Icon(
          Icons.password,
          color: Colors.green,
        ),
        labelText: "Confirm Password",
        labelStyle: TextStyle(color: Colors.black),
        hintText: "Confirm pasword",
        hintStyle: TextStyle(color: Colors.grey),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.red, width: 1),
        ),
        errorStyle: TextStyle(color: Colors.red),
      ),
    );
  }
}
