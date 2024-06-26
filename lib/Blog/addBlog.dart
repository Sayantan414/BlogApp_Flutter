import 'package:blogapp/NetworkHandler.dart';
import 'package:blogapp/Pages/HomePage.dart';
import 'package:flutter/material.dart';

class AddBlog extends StatefulWidget {
  const AddBlog({super.key, required this.type, required this.data});

  final Map<String, dynamic> data;
  final String type;

  @override
  _AddBlogState createState() => _AddBlogState();
}

class _AddBlogState extends State<AddBlog> {
  final _globalkey = GlobalKey<FormState>();
  TextEditingController _title = TextEditingController();
  TextEditingController _body = TextEditingController();
  // late XFile _imageFile;
  IconData iconphoto = Icons.image;
  NetworkHandler networkHandler = NetworkHandler();

  @override
  void initState() {
    super.initState();
    print(widget.data);

    if (widget.data.isNotEmpty) {
      print(widget.data);
      _title.text = widget.data["title"] ?? "";
      _body.text = widget.data["body"] ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(236, 211, 238, 196),
      appBar: AppBar(
        backgroundColor: Colors.white54,
        elevation: 0,
        leading: IconButton(
            icon: const Icon(
              Icons.clear,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        // actions: <Widget>[
        //   ElevatedButton(
        //     onPressed: () {
        //       if (_globalkey.currentState!.validate()) {
        //         showModalBottomSheet(
        //           context: context,
        //           builder: ((builder) => OverlayCard(
        //                 body: _body.text,
        //                 title: _title.text,
        //               )),
        //         );
        //       }
        //     },
        //     child: Text(
        //       "Preview",
        //       style: TextStyle(fontSize: 18),
        //     ),
        //   ),
        // ],
      ),
      body: Form(
        key: _globalkey,
        child: ListView(
          children: <Widget>[
            titleTextField(),
            bodyTextField(),
            SizedBox(
              height: 20,
            ),
            widget.type == "Add" ? addButton() : updateButton(),
          ],
        ),
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
          // prefixIcon: IconButton(
          //   icon: Icon(
          //     iconphoto,
          //     color: Color.fromARGB(255, 147, 222, 151),
          //   ),
          //   onPressed: takeCoverPhoto,
          // ),
        ),
        maxLength: 100,
        maxLines: null,
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
          Map<String, String> data = {
            "title": _title.text,
            "body": _body.text,
          };

          var response = await networkHandler.post1("/blogpost/Add", data);
          print("Data : " + response.body);

          if (response.statusCode == 200 || response.statusCode == 201) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
                (route) => false);
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
          Map<String, String> data = {
            "title": _title.text,
            "body": _body.text,
          };

          var response = await networkHandler.put(
              "/blogpost/update/${widget.data["_id"]}", data);
          print("Data : " + response.body);

          if (response.statusCode == 200 || response.statusCode == 201) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
                (route) => false);
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

  // void takeCoverPhoto() async {
  //   final imagePicker = ImagePicker();
  //   final pickedImage =
  //       await imagePicker.pickImage(source: ImageSource.gallery);
  //   setState(() {
  //     _imageFile = pickedImage!;
  //     iconphoto = Icons.check_box;
  //   });
  // }
}
