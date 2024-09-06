// import 'dart:io';

import 'dart:convert';
import 'dart:io';

import 'package:blogapp/NetworkHandler.dart';
import 'package:blogapp/Services/userService.dart';
import 'package:blogapp/Utils/colors.dart';
import 'package:blogapp/Utils/functions.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
  Map<String, dynamic> userDetails = {};
  File? _imageFile;

  final _globalkey = GlobalKey<FormState>();
  TextEditingController _firstname = TextEditingController();
  TextEditingController _lastname = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _conpassword = TextEditingController();
  bool _isConPasswordEnabled = false;
  bool picFlag = false;
  @override
  void initState() {
    super.initState();

    userDetails = getUserDetails();
    // print(userDetails);

    _firstname.text = userDetails['firstname'];
    _lastname.text = userDetails['lastname'];
    _email.text = userDetails['email'];
    // _firstname.text = userDetails['firstname'];

    // Add listener to password controller
    _password.addListener(() {
      final password = _password.text;

      if (password.length >= 4) {
        setState(() {
          _isConPasswordEnabled = true;
        });
      } else {
        setState(() {
          _isConPasswordEnabled = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _password.dispose();
    _conpassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorTheme(context)['primary'],
        elevation: 0,
        leading: IconButton(
            icon: Icon(
              Icons.clear,
              color: colorTheme(context)['button'],
            ),
            onPressed: () {
              Navigator.of(context).pop({'update': false});
            }),
      ),
      backgroundColor: colorTheme(context)['primary'],
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
                    "firstname": _firstname.text,
                    "lastname": _lastname.text,
                    "email": _email.text,
                    "password": _password.text,
                  };
                  var response = await updateUser(data);
                  print(response);

                  if (response['status'] == 'success') {
                    saveUserDetails(response["data"]);
                    setState(() {
                      circular = false;
                    });
                    Navigator.of(context).pop({'update': true});
                    // }
                  }
                }
              },
              child: Center(
                child: Container(
                  width: 200,
                  height: 50,
                  decoration: BoxDecoration(
                    color: colorTheme(context)['button'],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: circular
                        ? CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              colorTheme(context)['loader'],
                            ),
                          )
                        : Text(
                            "Update",
                            style: TextStyle(
                              color: colorTheme(context)['buttonText'],
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
            backgroundColor: colorTheme(context)['primary'],
            backgroundImage: userDetails['profilePhoto'] != null
                ? NetworkImage(userDetails['profilePhoto'])
                : AssetImage('assets/nouser.png') as ImageProvider,
            child: picFlag
                ? CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      colorTheme(context)['loader'],
                    ),
                  )
                : null, // No child if picFlag is false
          ),
          Positioned(
            bottom: 20.0,
            right: 20.0,
            child: InkWell(
              onTap: () async {
                setState(() {
                  picFlag = true;
                });
                final pickedFile =
                    await ImagePicker().pickImage(source: ImageSource.gallery);

                setState(() {
                  if (pickedFile != null) {
                    _imageFile = File(pickedFile.path);
                  } else {
                    return;
                  }
                });

                var response = await uploadProfilePhoto(_imageFile);
                // print(response);
                if (response['status'] == "success") {
                  setState(() {
                    userDetails["profilePhoto"] = response['data'];
                    picFlag = false;
                  });
                }
              },
              child: Icon(
                Icons.camera_alt,
                color: colorTheme(context)['primary'],
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
      controller: _firstname,
      style: TextStyle(
        color: colorTheme(context)['text'],
      ),
      validator: (value) {
        if (value!.isEmpty) return "Firstname can't be empty";

        return null;
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: colorTheme(context)['fillColor'],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: colorTheme(context)['tertiary'], // Custom border color
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: colorTheme(context)[
                'tertiary'], // Change this to your desired color for focused state
            width: 2,
          ),
        ),
        prefixIcon: Icon(
          Icons.person,
          color: colorTheme(context)['text'],
        ),
        labelText: "Firstname",
        labelStyle: TextStyle(color: colorTheme(context)['text']),
        hintText: "Enter your firstname",
        hintStyle: TextStyle(color: colorTheme(context)['text']),
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
      controller: _lastname,
      style: TextStyle(
        color: colorTheme(context)['text'],
      ),
      validator: (value) {
        if (value!.isEmpty) return "lastname can't be empty";

        return null;
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: colorTheme(context)['fillColor'],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: colorTheme(context)['tertiary'], // Custom border color
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: colorTheme(context)[
                'tertiary'], // Change this to your desired color for focused state
            width: 2,
          ),
        ),
        prefixIcon: Icon(
          Icons.person,
          color: colorTheme(context)['text'],
        ),
        labelText: "Lastname",
        labelStyle: TextStyle(color: colorTheme(context)['text']),
        hintText: "Enter your lastname",
        hintStyle: TextStyle(color: colorTheme(context)['text']),
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
      controller: _email,
      style: TextStyle(
        color: colorTheme(context)['text'],
      ),
      validator: (value) {
        if (value!.isEmpty) return "email can't be empty";

        return null;
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: colorTheme(context)['fillColor'],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: colorTheme(context)['tertiary'], // Custom border color
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: colorTheme(context)[
                'tertiary'], // Change this to your desired color for focused state
            width: 2,
          ),
        ),
        prefixIcon: Icon(
          Icons.email_outlined,
          color: colorTheme(context)['text'],
        ),
        labelText: "Email",
        labelStyle: TextStyle(color: colorTheme(context)['text']),
        hintText: "Enter your email",
        hintStyle: TextStyle(color: colorTheme(context)['text']),
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
      controller: _password,
      style: TextStyle(
        color: colorTheme(context)['text'],
      ),
      validator: (value) {
        if (value!.isEmpty) return "Password can't be empty";
        if (value.length < 4) return "Password must be at least 4 characters";

        return null;
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: colorTheme(context)['fillColor'],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: colorTheme(context)['tertiary'], // Custom border color
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: colorTheme(context)['tertiary'],
            width: 2,
          ),
        ),
        prefixIcon: Icon(
          Icons.password,
          color: colorTheme(context)['text'],
        ),
        labelText: "Password",
        labelStyle: TextStyle(color: colorTheme(context)['text']),
        hintText: "Enter password",
        hintStyle: TextStyle(color: colorTheme(context)['text']),
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
      controller: _conpassword,
      style: TextStyle(
        color: colorTheme(context)['text'],
      ),
      enabled: _isConPasswordEnabled,
      validator: (value) {
        if (value!.isEmpty) return "Confirm your password";
        if (value != _password.text) return "Passwords do not match";

        return null;
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: colorTheme(context)['fillColor'],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: colorTheme(context)['tertiary'], // Custom border color
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: colorTheme(context)['tertiary'],
            width: 2,
          ),
        ),
        prefixIcon: Icon(Icons.password, color: colorTheme(context)['text']),
        labelText: "Confirm Password",
        labelStyle: TextStyle(color: colorTheme(context)['text']),
        hintText: "Confirm password",
        hintStyle: TextStyle(color: colorTheme(context)['text']),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.red, width: 1),
        ),
        errorStyle: TextStyle(color: Colors.red),
      ),
    );
  }
}
