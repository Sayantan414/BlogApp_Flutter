import 'package:blogapp/NetworkHandler.dart';
import 'package:flutter/material.dart';

class Blog extends StatefulWidget {
  const Blog(
      {super.key,
      required this.title,
      required this.body,
      required this.username});

  final String title;
  final String body;
  final String username;

  @override
  State<Blog> createState() => _BlogState();
}

class _BlogState extends State<Blog> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 216, 234, 206),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 147, 222, 151),
        title: Text(
          'View',
          textAlign: TextAlign.center, // Align text at the center
        ),
        centerTitle: true, // Center the title text
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                widget.title,
                style: const TextStyle(
                  color: Color.fromARGB(255, 4, 88, 36),
                  fontSize: 24, // Large font size for the title
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12), // Add some vertical space
              Text(
                '• By ' + widget.username,
                style: const TextStyle(
                  color: Color.fromARGB(255, 30, 30, 30),
                  fontSize: 16, // Large font size for the title
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Divider(
                thickness: 0.8,
              ),
              const SizedBox(height: 16),
              // Body
              Text(
                widget.body,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color.fromARGB(221, 85, 84, 84),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
