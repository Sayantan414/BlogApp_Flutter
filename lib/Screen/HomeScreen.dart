import 'package:blogapp/Blog/Blogs.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(98, 197, 222, 184),
      body: SingleChildScrollView(
        child: Blogs(
          url: "/blogpost/getOtherBlog",
        ),
      ),
    );
  }
}
