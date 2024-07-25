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
      print(responseData);

      setState(() {
        data = responseData as List;
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
                  ...filteredData
                      .map((item) => Card(
                            elevation: 3,
                            margin: const EdgeInsets.all(8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            color: const Color.fromARGB(255, 206, 240, 206),
                            child: Row(
                              children: [
                                Expanded(
                                  child: ListTile(
                                    title: Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 17,
                                          backgroundColor: const Color.fromARGB(
                                              255, 206, 240, 206),
                                          backgroundImage: item
                                                  .containsKey("dp")
                                              ? AssetImage(
                                                  "assets/${item["dp"]}")
                                              : AssetImage("assets/nouser.png"),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          item["fullname"],
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            color:
                                                Color.fromARGB(255, 85, 85, 85),
                                          ),
                                        ),
                                        if (widget.type != "Own")
                                          item["like"].contains(username)
                                              ? Expanded(
                                                  child: Align(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        const Icon(
                                                          Icons.favorite,
                                                          color: Color.fromARGB(
                                                              212, 245, 31, 31),
                                                        ),
                                                        Text(
                                                          ' ${item["like"].length}',
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 16,
                                                            // fontWeight: FontWeight.bold,
                                                            color:
                                                                Color.fromARGB(
                                                                    215,
                                                                    23,
                                                                    23,
                                                                    23),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              : Expanded(
                                                  child: Align(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        Transform.scale(
                                                          scale: 1.5,
                                                          child: const Icon(
                                                            Icons
                                                                .favorite_outline,
                                                            size: 16,
                                                            color:
                                                                Color.fromARGB(
                                                                    214,
                                                                    92,
                                                                    92,
                                                                    92),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            width: 8),
                                                        Text(
                                                          '${item["like"].length}',
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 16,
                                                            color:
                                                                Color.fromARGB(
                                                                    215,
                                                                    23,
                                                                    23,
                                                                    23),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                      ],
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8),
                                          child: Text(
                                            item["title"],
                                            style: GoogleFonts.specialElite(
                                              textStyle: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                                color: Color.fromARGB(
                                                    255, 4, 88, 36),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Text(
                                          _truncateText(
                                              item["description"], 100),
                                          style: GoogleFonts.specialElite(
                                              textStyle: const TextStyle(
                                            // fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color:
                                                Color.fromARGB(221, 75, 75, 75),
                                          )),
                                        ),
                                        const SizedBox(
                                          height: 3,
                                        ),
                                      ],
                                    ),
                                    onTap: () {
                                      if (item["dp"] != null) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => Blog(
                                                title: item["title"],
                                                body: item["description"],
                                                username: item["fullname"],
                                                dp: item["dp"],
                                                id: item["_id"],
                                                likes: item['like']),
                                          ),
                                        ).then((value) => setState(() {
                                              item['like'] = value;
                                            }));
                                      }
                                    },
                                  ),
                                ),
                                widget.type == "Own"
                                    ? PopupMenuButton(
                                        itemBuilder: (BuildContext context) =>
                                            <PopupMenuEntry>[
                                          PopupMenuItem(
                                            child: ListTile(
                                              leading: const Icon(Icons.edit),
                                              title: const Text('Edit'),
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
                                              leading: const Icon(Icons.delete),
                                              title: const Text('Delete'),
                                              onTap: () async {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title:
                                                          const Text("Delete"),
                                                      content: const Text(
                                                          "Are you sure you want to delete this?"),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: const Text(
                                                            "No",
                                                            style: TextStyle(
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      4,
                                                                      88,
                                                                      36),
                                                            ),
                                                          ),
                                                        ),
                                                        TextButton(
                                                          onPressed: () async {
                                                            var response =
                                                                await networkHandler
                                                                    .delete(
                                                                        "/blogpost/delete/${item["_id"]}");
                                                            if (response.statusCode ==
                                                                    200 ||
                                                                response.statusCode ==
                                                                    201) {
                                                              fetchData();
                                                              ScaffoldMessenger
                                                                      .of(context)
                                                                  .clearSnackBars();
                                                              ScaffoldMessenger
                                                                      .of(context)
                                                                  .showSnackBar(
                                                                SnackBar(
                                                                  duration:
                                                                      const Duration(
                                                                          seconds:
                                                                              3),
                                                                  content:
                                                                      const Center(
                                                                    child: Text(
                                                                        'Item Deleted Successfully'),
                                                                  ),
                                                                  action:
                                                                      SnackBarAction(
                                                                    label: '',
                                                                    onPressed:
                                                                        () {},
                                                                  ),
                                                                ),
                                                              );
                                                            }
                                                            Navigator.pop(
                                                                context); // Close the dialog
                                                            Navigator.pop(
                                                                context); // Close the menu after tapping "Delete"
                                                          },
                                                          child: const Text(
                                                            "Yes",
                                                            style: TextStyle(
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      4,
                                                                      88,
                                                                      36),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
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
