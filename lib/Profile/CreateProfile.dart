// import 'dart:io';

import 'package:blogapp/NetworkHandler.dart';
import 'package:blogapp/Pages/HomePage.dart';
import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';

class CreatProfile extends StatefulWidget {
  const CreatProfile({super.key, required this.type, required this.data});

  final String type;
  final Map<String, dynamic> data;

  @override
  _CreatProfileState createState() => _CreatProfileState();
}

class _CreatProfileState extends State<CreatProfile> {
  final networkHandler = NetworkHandler();
  bool circular = false;
  bool updateDp = false;
  // XFile? _imageFile;

  final _globalkey = GlobalKey<FormState>();
  TextEditingController _name = TextEditingController();
  TextEditingController _profession = TextEditingController();
  TextEditingController _dob = TextEditingController();
  TextEditingController _titleline = TextEditingController();
  TextEditingController _about = TextEditingController();
  // final ImagePicker _picker = ImagePicker();
  String dp = "";
  String username = "";
  bool picFlag = false;

  @override
  void initState() {
    super.initState();
    dp = getDp();

    if (widget.data.isNotEmpty) {
      print(widget.data);
      username = widget.data["username"] ?? "";
      _name.text = widget.data["name"] ?? "";
      _profession.text = widget.data["profession"] ?? "";
      _dob.text = widget.data["DOB"] ?? "";
      _titleline.text = widget.data["titleline"] ?? "";
      _about.text = widget.data["about"] ?? "";
    }
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
              Navigator.pop(context);
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
            nameTextField(),
            const SizedBox(
              height: 20,
            ),
            professionTextField(),
            const SizedBox(
              height: 20,
            ),
            dobField(),
            const SizedBox(
              height: 20,
            ),
            titleTextField(),
            const SizedBox(
              height: 20,
            ),
            aboutTextField(),
            SizedBox(
              height: 20,
            ),
            widget.type == "Add"
                ? InkWell(
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
                        var response =
                            await networkHandler.post("/profile/add", data);
                        if (response.statusCode == 200 ||
                            response.statusCode == 201) {
                          // if (_imageFile?.path != null) {
                          //   var imageResponse = await networkHandler.patchImage(
                          //       "/profile/add/image", _imageFile!.path);
                          //   if (imageResponse.statusCode == 200) {
                          //     setState(() {
                          //       circular = false;
                          //     });
                          //     Navigator.of(context).pushAndRemoveUntil(
                          //         MaterialPageRoute(
                          //             builder: (context) => HomePage()),
                          //         (route) => false);
                          //   }
                          // } else {
                          setState(() {
                            circular = false;
                          });
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => HomePage()),
                              (route) => false);
                          // }
                        }
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
                                  backgroundColor: Colors
                                      .green, // Background color of the progress indicator
                                )
                              : const Text(
                                  "Submit",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  )
                : InkWell(
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
                        var response = await networkHandler.put(
                            "/profile/update/${widget.data["_id"]}", data);
                        print(data);
                        if (response.statusCode == 200 ||
                            response.statusCode == 201) {
                          setState(() {
                            circular = false;
                          });
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => HomePage()),
                              (route) => false);
                          // }
                        }
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
                                  backgroundColor: Colors
                                      .green, // Background color of the progress indicator
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
            backgroundImage: !picFlag ? AssetImage("assets/${dp}") : null,
            child: picFlag ? CircularProgressIndicator() : null,
          ),
          Positioned(
            bottom: 20.0,
            right: 20.0,
            child: InkWell(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: ((builder) => bottomSheet1()),
                );
              },
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

  // Widget bottomSheet() {
  //   return Container(
  //     height: 100.0,
  //     width: MediaQuery.of(context).size.width,
  //     margin: EdgeInsets.symmetric(
  //       horizontal: 20,
  //       vertical: 20,
  //     ),
  //     child: Column(
  //       children: <Widget>[
  //         Text(
  //           "Choose Profile photo",
  //           style: TextStyle(
  //             fontSize: 20.0,
  //           ),
  //         ),
  //         SizedBox(
  //           height: 20,
  //         ),
  //         Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
  //           ElevatedButton.icon(
  //             onPressed: () {
  //               takePhoto(ImageSource.camera);
  //             },
  //             icon: Icon(Icons.camera),
  //             label: Text("Camera"),
  //           ),
  //           ElevatedButton.icon(
  //             onPressed: () {
  //               takePhoto(ImageSource.gallery);
  //             },
  //             icon: Icon(Icons.image),
  //             label: Text("Gallery"),
  //           ),
  //         ])
  //       ],
  //     ),
  //   );
  // }

  Widget bottomSheet1() {
    return Container(
      height: 370,
      color: Color.fromARGB(98, 197, 222, 184),
      width: MediaQuery.of(context).size.width,
      child: Card(
        color: Color.fromARGB(255, 222, 241, 222),
        margin: const EdgeInsets.all(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  iconCreation(AssetImage("assets/lion.webp"), "lion.webp"),
                  const SizedBox(
                    width: 40,
                  ),
                  iconCreation(AssetImage("assets/nkn.webp"), "nkn.webp"),
                  const SizedBox(
                    width: 40,
                  ),
                  iconCreation(AssetImage("assets/angry.webp"), "angry.webp")
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  iconCreation(AssetImage("assets/cat.webp"), "cat.webp"),
                  const SizedBox(
                    width: 40,
                  ),
                  iconCreation(
                      AssetImage("assets/crocodile.webp"), "crocodile.webp"),
                  const SizedBox(
                    width: 40,
                  ),
                  iconCreation(AssetImage("assets/tiger.webp"), "tiger.webp")
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    iconCreation(AssetImage("assets/panda.webp"), "panda.webp"),
                    const SizedBox(
                      width: 40,
                    ),
                    iconCreation(AssetImage("assets/owl.webp"), "owl.webp"),
                    const SizedBox(
                      width: 40,
                    ),
                    iconCreation(AssetImage("assets/dog.png"), "dog.png")
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget iconCreation(AssetImage image, String text) {
    return InkWell(
      onTap: () async {
        Navigator.pop(context);
        setState(() {
          picFlag = true;
        });
        dp = text;
        print(dp);
        Map<String, String> data = {
          "dp": dp,
        };
        var response =
            await networkHandler.patch("/user/update/${username}", data);
        print(data);
        if (response.statusCode == 200 || response.statusCode == 201) {
          saveDp(dp);
          setState(() {
            picFlag = false;
          });
          dp = getDp();
        }
      },
      child: Stack(
        children: [
          Column(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: Color.fromARGB(255, 222, 241, 222),
                child: ClipOval(
                  child: Image(
                    image: image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
          // Positioned(
          //   bottom: 0,
          //   right: 0,
          //   child: Container(
          //     decoration: BoxDecoration(
          //       shape: BoxShape.circle,
          //       color: Colors.teal,
          //     ),
          //     padding: EdgeInsets.all(2),
          //     child: Icon(
          //       Icons.check,
          //       color: Colors.white,
          //       size: 18.0,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  // void takePhoto(ImageSource source) async {
  //   final pickedFile = await _picker.pickImage(
  //     source: source,
  //   );
  //   setState(() {
  //     _imageFile =
  //         (pickedFile != null ? File(pickedFile.path) : null) as XFile?;
  //   });
  // }

  Widget nameTextField() {
    return TextFormField(
      controller: _name,
      validator: (value) {
        if (value!.isEmpty) return "Name can't be empty";

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
                .orange, // Change this to your desired color for focused state
            width: 2,
          ),
        ),
        prefixIcon: const Icon(
          Icons.person,
          color: Colors.green,
        ),
        labelText: "Name",
        labelStyle: TextStyle(color: Colors.black),
        hintText: "Enter your name",
        hintStyle: TextStyle(color: Colors.grey),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.red, width: 1),
        ),
        errorStyle: TextStyle(color: Colors.red),
      ),
    );
  }

  Widget professionTextField() {
    return TextFormField(
      controller: _profession,
      validator: (value) {
        if (value!.isEmpty) return "Profession can't be empty";

        return null;
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: Colors.teal,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: Colors.orange,
            width: 2,
          ),
        ),
        prefixIcon: Icon(
          Icons.work,
          color: Colors.green,
        ),
        labelText: "Profession",
        labelStyle: TextStyle(color: Colors.black),
        hintText: "Enter your profession",
        hintStyle: TextStyle(color: Colors.grey),
        helperText: "Profession can't be empty",
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.red, width: 1),
        ),
        errorStyle: TextStyle(color: Colors.red),
      ),
    );
  }

  Widget dobField() {
    return TextFormField(
      controller: _dob,
      validator: (value) {
        if (value!.isEmpty) return "DOB can't be empty";

        return null;
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: Colors.teal,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: Colors.orange,
            width: 2,
          ),
        ),
        prefixIcon: Icon(
          Icons.calendar_today,
          color: Colors.green,
        ),
        labelText: "Date Of Birth",
        labelStyle: TextStyle(color: Colors.black),
        hintText: "Provide DOB on dd/mm/yyyy",
        hintStyle: TextStyle(color: Colors.grey),
        helperText: "DOB can't be empty",
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.red, width: 1),
        ),
        errorStyle: TextStyle(color: Colors.red),
      ),
    );
  }

  Widget titleTextField() {
    return TextFormField(
      controller: _titleline,
      validator: (value) {
        if (value!.isEmpty) return "Title can't be empty";

        return null;
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: Colors.teal,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: Colors.orange,
            width: 2,
          ),
        ),
        prefixIcon: Icon(
          Icons.title,
          color: Colors.green,
        ),
        labelText: "Title",
        labelStyle: TextStyle(color: Colors.black),
        hintText: "Enter your title",
        hintStyle: TextStyle(color: Colors.grey),
        helperText: "Title can't be empty",
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.red, width: 1),
        ),
        errorStyle: TextStyle(color: Colors.red),
      ),
    );
  }

  Widget aboutTextField() {
    return TextFormField(
      controller: _about,
      validator: (value) {
        if (value!.isEmpty) return "About can't be empty";

        return null;
      },
      maxLines: 4,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: Colors.teal,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: Colors.orange,
            width: 2,
          ),
        ),
        labelText: "About",
        labelStyle: TextStyle(color: Colors.black),
        hintText: "Write about yourself",
        hintStyle: TextStyle(color: Colors.grey),
        helperText: "About can't be empty",
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.red, width: 1),
        ),
        errorStyle: TextStyle(color: Colors.red),
      ),
    );
  }
}
