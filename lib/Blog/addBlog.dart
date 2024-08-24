import 'dart:io';

import 'package:blogapp/CustumWidget/OverlayCard.dart';
import 'package:blogapp/NetworkHandler.dart';
import 'package:blogapp/Pages/HomePage.dart';
import 'package:blogapp/Profile/ProfileScreen.dart';
import 'package:blogapp/Services/categoryService.dart';
import 'package:blogapp/Services/postService.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddBlog extends StatefulWidget {
  const AddBlog({super.key, required this.action, required this.data});

  final Map data;
  final String action;

  @override
  _AddBlogState createState() => _AddBlogState();
}

class _AddBlogState extends State<AddBlog> {
  final _globalkey = GlobalKey<FormState>();
  TextEditingController _title = TextEditingController();
  TextEditingController _body = TextEditingController();
  IconData iconphoto = Icons.image;
  String? _selectedCategory;
  List<dynamic> categories = [];

  File? _imageFile;

  void initState() {
    // TODO: implement initState
    super.initState();
    fetchCategory();

    // print(widget.data);

    if (widget.action == "Edit") {
      _title.text = widget.data['title'];
      _body.text = widget.data['description'];
      // _selectedCategory = widget.data['category'];
      // _imageFile = widget.data['photo'];
      if (widget.data['category'] is String) {
        _selectedCategory = widget.data['category'];
      } else {
        _selectedCategory = widget.data['category']['_id'];
      }
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void fetchCategory() async {
    try {
      // isLoading = true;
      var responseData = await fetchAllCategory();
      // print(responseData);

      setState(() {
        categories = responseData;

        // isLoading = false;
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(236, 211, 238, 196),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(236, 211, 238, 196),
        elevation: 0,
        leading: IconButton(
            icon: Icon(
              Icons.clear,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: Form(
        key: _globalkey,
        child: ListView(
          children: <Widget>[
            _uploadBannerField(),
            categoryDropdownField(),
            titleTextField(),
            bodyTextField(),
            SizedBox(
              height: 20,
            ),
            if (widget.action == 'Add') addButton(),
            if (widget.action == 'Edit') updateButton(),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _uploadBannerField() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          if (widget.action == "Edit" &&
              _imageFile == null &&
              widget.data["photo"] != null)
            Center(
              child: Image.network(
                widget.data["photo"],
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            )
          else if (_imageFile != null)
            Image.file(
              _imageFile!,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            )
          else
            Center(
              child: const Icon(Icons.image, size: 100, color: Colors.white),
            ),
          SizedBox(height: 10),
          Center(
            child: ElevatedButton(
              onPressed: _pickImage,
              child: Text(
                'Choose a Image',
                style: TextStyle(color: Colors.teal),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget titleTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ),
      child: TextFormField(
        controller: _title,
        validator: (value) {
          if (value!.isEmpty) {
            return "Title can't be empty";
          } else if (value.length > 100) {
            return "Title length should be <=100";
          }
          return null;
        },
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Color.fromARGB(255, 45, 183, 52),
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.blue,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          labelText: "Add Blog Title",
          labelStyle: const TextStyle(color: Colors.black),
        ),
        maxLength: 100,
        maxLines: null,
      ),
    );
  }

  Widget categoryDropdownField() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ),
      child: DropdownButtonFormField<String>(
        value: _selectedCategory,
        onChanged: (String? newValue) {
          setState(() {
            _selectedCategory = newValue;
          });
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please select a category";
          }
          return null;
        },
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Color.fromARGB(255, 147, 222, 151),
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.blue,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          labelText: "Select Category",
          labelStyle: TextStyle(color: Colors.black),
        ),
        items: categories.map<DropdownMenuItem<String>>((dynamic category) {
          return DropdownMenuItem<String>(
            value: category['_id'],
            child: Text(category['title']),
          );
        }).toList(),
      ),
    );
  }

  Widget bodyTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ),
      child: TextFormField(
        controller: _body,
        validator: (value) {
          if (value!.isEmpty) {
            return "Body can't be empty";
          }
          return null;
        },
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Color.fromARGB(255, 147, 222, 151),
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.blue,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          labelText: "Provide Body Your Blog",
          labelStyle: TextStyle(color: Colors.black),
        ),
        maxLines: null,
      ),
    );
  }

  Widget addButton() {
    return InkWell(
      onTap: () async {
        if (_globalkey.currentState!.validate()) {
          await createPost(
              _title.text, _body.text, _selectedCategory!, _imageFile);
        }
      },
      child: Center(
        child: Container(
          height: 50,
          width: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Color.fromARGB(255, 45, 183, 52),
          ),
          child: const Center(
              child: Text(
            "Add Blog",
            style: TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          )),
        ),
      ),
    );
  }

  Widget updateButton() {
    return InkWell(
      onTap: () async {
        if (_globalkey.currentState!.validate()) {
          var r = await updatePost(_title.text, _body.text, _selectedCategory!,
              _imageFile, widget.data['_id']);
          if (r.isNotEmpty) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfileScreen(),
              ),
            );
          }
        }
      },
      child: Center(
        child: Container(
          height: 50,
          width: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Color.fromARGB(255, 45, 183, 52),
          ),
          child: const Center(
              child: Text(
            "Update Blog",
            style: TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          )),
        ),
      ),
    );
  }
}
