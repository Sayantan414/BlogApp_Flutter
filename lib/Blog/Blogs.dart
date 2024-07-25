import 'dart:convert';

import 'package:blogapp/Blog/Blog.dart';
import 'package:blogapp/Blog/addBlog.dart';

import 'package:blogapp/NetworkHandler.dart';
import 'package:blogapp/Services/postService.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Blogs extends StatefulWidget {
  const Blogs({super.key, required this.url, required this.type});
  final String url;
  final String type;

  @override
  _BlogsState createState() => _BlogsState();
}

class _BlogsState extends State<Blogs> {
  NetworkHandler networkHandler = NetworkHandler();
  List<dynamic> data = [];
  bool isLoading = true;
  String trimmedText = '';
  String text = '';
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> filteredData = [];
  String username = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  void fetchData() async {
    try {
      isLoading = true;
      var responseData = await await fetchAllPost();
      // print(responseData);

      setState(() {
        data = responseData;
        filteredData = data;
        print(filteredData[0]['title']);
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  void filterBlogPosts(String query) {
    setState(() {
      filteredData = data.where((item) {
        String title = item["title"].toLowerCase();
        String body = item["description"].toLowerCase();
        String username = item["fullname"].toLowerCase();
        return title.contains(query.toLowerCase()) ||
            body.contains(query.toLowerCase()) ||
            username.contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        fetchData();
      }, // Callback function to fetch data
      child: data.isNotEmpty
          ? SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 8.0, left: 5.0, right: 5.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 249, 249, 249),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              onChanged: filterBlogPosts,
                              decoration: const InputDecoration(
                                hintText: 'Search...',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 35,
                            child: IconButton(
                              icon: const Icon(Icons.cancel),
                              onPressed: () {
                                _searchController.clear();
                                filterBlogPosts('');
                                FocusScope.of(context).unfocus();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ...filteredData.map((item) => Card(
                        elevation: 3,
                        margin: const EdgeInsets.only(top: 5),
                        color: const Color.fromARGB(255, 206, 240, 206),
                        child: Stack(
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Image.network(
                                  item['photo'],
                                  fit: BoxFit.cover,
                                  height: 200,
                                  width: double.infinity,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    item['title'],
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Positioned(
                              top: 8,
                              left: 8,
                              child: Text(
                                "vjyhvjhyhj", // Replace with item['username']
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  backgroundColor: Colors.white,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: PopupMenuButton<String>(
                                onSelected: (String value) {
                                  // Handle the selected value
                                },
                                itemBuilder: (BuildContext context) {
                                  return <String>['Option 1', 'Option 2']
                                      .map((String choice) {
                                    return PopupMenuItem<String>(
                                      value: choice,
                                      child: Text(choice),
                                    );
                                  }).toList();
                                },
                                icon: Icon(Icons.more_vert),
                              ),
                            ),
                          ],
                        ),
                      ))
                ],
              ),
            )
          : _noData(),
    );
  }

  String _truncateText(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    } else {
      return text.substring(0, maxLength) + ' more...';
    }
  }

  _noData() {
    return Center(
      child: isLoading
          ? LoadingAnimationWidget.fourRotatingDots(
              // LoadingAnimationwidget that call the
              color: const Color.fromARGB(
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
