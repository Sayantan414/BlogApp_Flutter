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
        print(filteredData[0]['viewsCount']);
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
        String fullname = item['user'][0]["fullname"].toLowerCase();
        return title.contains(query.toLowerCase()) ||
            body.contains(query.toLowerCase()) ||
            fullname.contains(query.toLowerCase());
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
                        color: Color.fromARGB(255, 235, 244, 235),
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
                  ...filteredData.map((item) => InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Blog(post: item),
                            ),
                          );
                        },
                        child: Container(
                          margin:
                              EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            gradient: const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color.fromARGB(255, 200, 230, 190),
                                Color.fromARGB(255, 220, 244, 209),
                                Color.fromARGB(255, 235, 250, 220),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // First Row: CircleAvatar, Fullname, and PopupMenuButton
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    // CircleAvatar with profile photo
                                    item['user'][0]['profilePhoto'] != null
                                        ? CircleAvatar(
                                            backgroundImage: NetworkImage(
                                                item['user'][0]
                                                    ['profilePhoto']),
                                            radius: 20,
                                            backgroundColor: Colors.transparent,
                                          )
                                        : const CircleAvatar(
                                            backgroundImage:
                                                AssetImage('assets/nouser.png'),
                                            radius: 20,
                                            backgroundColor: Colors.transparent,
                                          ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item['user'][0]['fullname'],
                                            style: GoogleFonts.roboto(
                                              textStyle: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                color: Color.fromARGB(
                                                    255, 51, 51, 51),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            item[
                                                'daysAgo'], // Replace with actual timestamp
                                            style: GoogleFonts.roboto(
                                              textStyle: const TextStyle(
                                                fontSize: 12,
                                                color: Color.fromARGB(
                                                    255, 96, 95, 95),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          showModalBottomSheet(
                                            context: context,
                                            builder: ((builder) =>
                                                bottomSheet()),
                                          );
                                        },
                                        child: Text(
                                          "•••",
                                          style: TextStyle(fontSize: 18.0),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Post Image
                              if (item['photo'] != null)
                                ClipRRect(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(12)),
                                  child: Image.network(
                                    item['photo'],
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: 200,
                                  ),
                                ),
                              // Post Description or Title
                              if (item['title'] != null)
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 12.0, left: 12.0),
                                  child: Text(
                                    item['title'],
                                    // "vyhfytfyt ftyfytfdytf fyfytytfy ftys4aarest tguyviugi",
                                    style: GoogleFonts.roboto(
                                      textStyle: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Color.fromARGB(255, 87, 86, 86),
                                      ),
                                    ),
                                  ),
                                ),
                              // Post Interaction
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0, vertical: 4.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Views text on the left
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.visibility,
                                          size: 22,
                                          color: Colors.blue,
                                        ),
                                        const SizedBox(
                                            width:
                                                8), // Space between icon and text
                                        Text(
                                          item['viewsCount'].toString(),
                                          style: const TextStyle(
                                            color:
                                                Color.fromARGB(255, 1, 42, 19),
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                    // Likes text on the right
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.thumb_up,
                                          size: 22,
                                          color:
                                              Color.fromARGB(255, 39, 174, 96),
                                        ),
                                        const SizedBox(
                                            width:
                                                8), // Space between icon and text
                                        Text(
                                          item['likesCount'].toString(),
                                          style: const TextStyle(
                                            color:
                                                Color.fromARGB(255, 1, 42, 19),
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ))
                ],
              ),
            )
          : _noData(),
    );
  }

  Widget bottomSheet() {
    return Container(
      height: 320.0,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              color: Color.fromARGB(255, 230, 251, 223),
              margin: const EdgeInsets.symmetric(vertical: 1.0),
              elevation: 4.0,
              child: Container(
                width: double.infinity, // Make the card full width
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text and Arrow Pair 1
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'View Post',
                            style: GoogleFonts.roboto(
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Color.fromARGB(255, 4, 88, 36),
                              ),
                            ),
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                    Text(
                      'Subtext 1',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    Divider(height: 20, color: Colors.grey[300]),
                    SizedBox(height: 16), // Space between pairs

                    // Text and Arrow Pair 2
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'Edit Post',
                            style: GoogleFonts.roboto(
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Color.fromARGB(255, 4, 88, 36),
                              ),
                            ),
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                    Text(
                      'Subtext 2',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    Divider(height: 20, color: Colors.grey[300]),
                    SizedBox(height: 16), // Space between pairs

                    // Text and Arrow Pair 3
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'Delete Post',
                            style: GoogleFonts.roboto(
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Color.fromARGB(255, 4, 88, 36),
                              ),
                            ),
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                    Text(
                      'Subtext 3',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    Divider(height: 20, color: Colors.grey[300]),
                    SizedBox(height: 16), // Space between pairs

                    // Text and Arrow Pair 4
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'Block User',
                            style: GoogleFonts.roboto(
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Color.fromARGB(255, 4, 88, 36),
                              ),
                            ),
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                    Text(
                      'Subtext 4',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
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
