import 'dart:convert';

import 'package:blogapp/Blog/Blog.dart';

import 'package:blogapp/NetworkHandler.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Blogs extends StatefulWidget {
  const Blogs({super.key, required this.url});
  final String url;

  @override
  _BlogsState createState() => _BlogsState();
}

class _BlogsState extends State<Blogs> {
  NetworkHandler networkHandler = NetworkHandler();
  List<dynamic> data = [];
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  void fetchData() async {
    try {
      var response = await networkHandler.get(widget.url);
      var responseData = json.decode(response);
      print(responseData.runtimeType); // Print the type of responseData
      setState(() {
        data = responseData; // Assuming responseData is a map with a 'data' key
        print(data);
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching data: $e');
      // Handle error, e.g., show error message to the user
    }
  }

  @override
  Widget build(BuildContext context) {
    return data.isNotEmpty
        ? SingleChildScrollView(
            child: Column(
              children: [
                ...data
                    .map((item) => Card(
                          elevation: 3,
                          margin: EdgeInsets.all(8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          color: Color.fromARGB(
                              255, 206, 240, 206), // Set card background color
                          child: ListTile(
                            title: Row(
                              // Create a Row for username and CircleAvatar

                              children: [
                                CircleAvatar(
                                  radius: 17,
                                  backgroundColor:
                                      const Color.fromARGB(255, 147, 222, 151),
                                  child: Text(
                                    item["username"][0]
                                        .toUpperCase(), // Display first letter of username
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                    width:
                                        8), // Add some space between CircleAvatar and username
                                Text(
                                  item[
                                      "username"], // Show the name at the top of the card
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Color.fromARGB(255, 85, 85,
                                        85), // Set username color to black
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8),
                                  child: Text(
                                    item["title"],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Color.fromARGB(
                                          255, 4, 88, 36), // Set title color
                                    ),
                                  ),
                                ),
                                Text(
                                  item["body"],
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Color.fromARGB(
                                        221, 75, 75, 75), // Set body color
                                  ),
                                ),
                              ],
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Blog(
                                    title: item["title"],
                                    body: item["body"],
                                    username: item["username"],
                                  ),
                                ),
                              );
                            },
                          ),
                        ))
                    .toList(),
              ],
            ),
          )
        : _noData();
  }

  _noData() {
    return Center(
      child: isLoading
          ? LoadingAnimationWidget.fourRotatingDots(
              // LoadingAnimationwidget that call the
              color: Color.fromARGB(
                  230, 80, 208, 142), // staggereddotwave animation
              size: 50,
            )
          : const Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20,
                ),
                Text(
                  "We don't have any Blog Yet",
                  style: TextStyle(
                      // color: myColors["desabled"],
                      ),
                )
              ],
            ),
    );
  }
}
