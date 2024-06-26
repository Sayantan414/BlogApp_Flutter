import 'dart:convert';

import 'package:blogapp/Profile/otherUserProfile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:blogapp/NetworkHandler.dart';

class Blog extends StatefulWidget {
  const Blog(
      {super.key,
      required this.title,
      required this.body,
      required this.username,
      required this.dp,
      required this.id,
      required this.likes});

  final String title;
  final String body;
  final String username;
  final String dp;
  final String id;
  final List<dynamic> likes;

  @override
  State<Blog> createState() => _BlogState();
}

class _BlogState extends State<Blog> {
  NetworkHandler networkHandler = NetworkHandler();
  bool likeFlag = false;
  String user = '';
  List<dynamic> likings = [];
  int noslikes = 0;
  List<dynamic> pictures = [];
  bool seeLikeDps = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    likings = widget.likes;
    noslikes = likings.length;
    user = getUsername();
    likeFlag = likings.contains(user);
    pictures = [];
    seeLikeDps = false;
    fetchDp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 216, 234, 206),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop(likings);
          },
        ),
        backgroundColor: const Color.fromARGB(255, 147, 222, 151),
        title: const Text(
          'View',
          textAlign: TextAlign.center, // Align text at the center
        ),
        centerTitle: true, // Center the title text
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                widget.title,
                style: GoogleFonts.specialElite(
                    textStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Color.fromARGB(255, 4, 88, 36),
                )),
              ),
              const SizedBox(height: 12), // Add some vertical space
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OtherUserProfile(
                              username: widget.username, dp: widget.dp),
                        ),
                      );
                    },
                    child: Text(
                      '• By ' + widget.username,
                      style: GoogleFonts.coveredByYourGrace(
                        textStyle: const TextStyle(
                          // fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OtherUserProfile(
                              username: widget.username, dp: widget.dp),
                        ),
                      );
                    },
                    child: CircleAvatar(
                      radius: 15,
                      backgroundColor: const Color.fromARGB(255, 206, 240, 206),
                      backgroundImage: AssetImage("assets/${widget.dp}"),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (!likeFlag)
                            GestureDetector(
                              onTap: () async {
                                try {
                                  setState(() {
                                    likeFlag = true;
                                  });
                                  var response = await networkHandler
                                      .putl("/blogpost/like/${widget.id}");
                                  print(response);
                                  var resData = json.decode(response);
                                  var data = resData['data'];
                                  // print(response);
                                  // print(resData);
                                  print(data);
                                  setState(() {
                                    likings = data['like'];
                                    noslikes = likings.length;
                                    likeFlag = likings.contains(user);
                                    fetchDp();
                                  });
                                } catch (e) {
                                  print(e);
                                }
                              },
                              child: const Icon(
                                Icons.favorite_outline,
                                size: 25,
                                color: Color.fromARGB(214, 92, 92, 92),
                              ),
                            ),
                          if (likeFlag)
                            GestureDetector(
                              onTap: () async {
                                try {
                                  setState(() {
                                    likeFlag = false;
                                  });
                                  var response = await networkHandler
                                      .putl("/blogpost/like/${widget.id}");
                                  print(response);
                                  var resData = json.decode(response);
                                  var data = resData['data'];

                                  setState(() {
                                    likings = data['like'];
                                    noslikes = likings.length;
                                    likeFlag = likings.contains(user);
                                    fetchDp();
                                  });
                                } catch (e) {
                                  print(e);
                                }
                              },
                              child: const Icon(
                                Icons.favorite,
                                size: 25,
                                color: Color.fromARGB(212, 245, 31, 31),
                              ),
                            ),
                          const SizedBox(width: 4),
                          IgnorePointer(
                            ignoring: !seeLikeDps,
                            child: InkWell(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: ((builder) => bottomSheet()),
                                );
                              },
                              child: Text(
                                '◉ $noslikes likes',
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.blueGrey,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Divider(
                thickness: 0.8,
              ),
              const SizedBox(height: 16),
              // Body
              Text(
                widget.body,
                style: GoogleFonts.specialElite(
                    textStyle: const TextStyle(
                  // fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color.fromARGB(221, 75, 75, 75),
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget bottomSheet() {
    return Container(
      height: 300.0,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            for (int i = 0; i < likings.length; i++)
              ListTile(
                leading: CircleAvatar(
                    backgroundImage: AssetImage("assets/${pictures[i]}")),
                title: Text(likings[i]),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> fetchDp() async {
    pictures = [];
    for (var element in likings) {
      var res = await networkHandler.get("/user/${element}");
      var resData = json.decode(res);
      var dp = resData['data']['dp'];
      setState(() {
        pictures.add(dp);
      });
    }
    seeLikeDps = true;
    print(pictures);
  }
}
