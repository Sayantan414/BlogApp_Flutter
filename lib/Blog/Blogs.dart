import 'dart:convert';

import 'package:blogapp/Blog/Blog.dart';
import 'package:blogapp/Blog/addBlog.dart';

import 'package:blogapp/NetworkHandler.dart';
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
  // Define a TextEditingController for the search query
  final TextEditingController _searchController = TextEditingController();

// Define a filteredData list to store the filtered blog posts
  List<dynamic> filteredData = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  void fetchData() async {
    try {
      isLoading = true;
      var response = await networkHandler.get(widget.url);
      var responseData = json.decode(response);
      print(responseData.runtimeType);
      setState(() {
        data = responseData;
        filteredData = data;
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
        String body = item["body"].toLowerCase();
        String username = item["username"].toLowerCase();
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
                    padding: EdgeInsets.only(top: 8.0, left: 5.0, right: 5.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 249, 249, 249),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
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
                              icon: Icon(Icons.cancel),
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
                  ...filteredData
                      .map((item) => Card(
                            elevation: 3,
                            margin: EdgeInsets.all(8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            color: Color.fromARGB(255, 206, 240, 206),
                            child: Row(
                              children: [
                                Expanded(
                                  child: ListTile(
                                    title: Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 17,
                                          backgroundColor:
                                              Color.fromARGB(255, 128, 38, 206),
                                          child: Text(
                                            item["username"][0].toUpperCase(),
                                            style: GoogleFonts.roboto(
                                              textStyle: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          item["username"],
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            color:
                                                Color.fromARGB(255, 85, 85, 85),
                                          ),
                                        ),
                                      ],
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsets.symmetric(vertical: 8),
                                          child: Text(
                                            item["title"],
                                            style: GoogleFonts.specialElite(
                                              textStyle: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                                color: Color.fromARGB(
                                                    255, 4, 88, 36),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Text(
                                          _truncateText(item["body"], 100),
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color:
                                                Color.fromARGB(221, 75, 75, 75),
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
                                ),
                                widget.type == "Own"
                                    ? PopupMenuButton(
                                        itemBuilder: (BuildContext context) =>
                                            <PopupMenuEntry>[
                                          PopupMenuItem(
                                            child: ListTile(
                                              leading: Icon(Icons.edit),
                                              title: Text('Edit'),
                                              onTap: () {
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        AddBlog(
                                                      type: "Edit",
                                                      data: item,
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                          PopupMenuItem(
                                            child: ListTile(
                                              leading: Icon(Icons.delete),
                                              title: Text('Delete'),
                                              onTap: () async {
                                                var response =
                                                    await networkHandler.delete(
                                                        "/blogpost/delete/${item["_id"]}");
                                                if (response.statusCode ==
                                                        200 ||
                                                    response.statusCode ==
                                                        201) {
                                                  fetchData();
                                                }
                                              },
                                            ),
                                          ),
                                        ],
                                      )
                                    : Container(),
                              ],
                            ),
                          ))
                      .toList(),
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
