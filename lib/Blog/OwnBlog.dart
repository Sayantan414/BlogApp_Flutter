import 'dart:convert';

import 'package:blogapp/Services/postService.dart';
import 'package:blogapp/Services/userService.dart';
import 'package:blogapp/Utils/functions.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OwnBlog extends StatefulWidget {
  const OwnBlog({super.key, required this.post});

  final Map post;

  @override
  State<OwnBlog> createState() => _OwnBlogState();
}

class _OwnBlogState extends State<OwnBlog> {
  bool likeFlag = false;
  Map<String, dynamic> userDetails = {};
  bool like = false;
  bool dislike = false;
  bool followingButton = true;
  bool follow = false;

  @override
  void initState() {
    super.initState();
    userDetails = getUserDetails();
    print(widget.post);

    // print(userDetails);
    viewDetailPost();
    like = widget.post["likes"].contains(userDetails["id"]);
    dislike = widget.post["dislikes"].contains(userDetails["id"]);
    // print(widget.post);
    // print(follow);
  }

  viewDetailPost() async {
    var response = await viewPost(widget.post["id"]);
    // print(response);
    if (response['status'] == "success") {
      setState(() {
        widget.post['viewsCount'] = response["data"]["viewsCount"];
        widget.post['numViews'] = response["data"]["numViews"];
      });
    }
  }

  String _truncateText(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    } else {
      return text.substring(0, maxLength) + '...';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 225, 235, 225),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop({});
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
          padding: const EdgeInsets.all(0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.post['photo'] != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 2.0),
                  child: Image.network(
                    widget.post['photo'],
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 200,
                  ),
                ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                child: Text(
                  widget.post['title'] ?? '',
                  style: GoogleFonts.roboto(
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Color.fromARGB(255, 4, 88, 36),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12), // Add some vertical space
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      // Navigate to the other user's profile
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        _truncateText('• By ${userDetails["name"]}', 16),
                        style: GoogleFonts.lato(
                          textStyle: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      // Navigate to the other user's profile
                    },
                    child: (userDetails["photo"] != null
                        ? CircleAvatar(
                            backgroundImage: NetworkImage(userDetails["photo"]),
                            radius: 20,
                            backgroundColor: Colors.transparent,
                          )
                        : const CircleAvatar(
                            backgroundImage: AssetImage('assets/nouser.png'),
                            radius: 20,
                            backgroundColor: Colors.transparent,
                          )),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [Text("• ${widget.post['daysAgo']}")],
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5.0, vertical: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 95.0,
                      height: 30.0,
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          setState(() {
                            like = !like;
                          });
                          var response = await likePost(widget.post["id"]);
                          print(response);
                          // print(widget.post['likesCount']);
                          setState(() {
                            widget.post['likesCount'] =
                                response["data"]["likesCount"].toString();
                            widget.post['likes'] = response["data"]["likes"];
                            widget.post['dislikesCount'] =
                                response["data"]["dislikesCount"].toString();
                            widget.post['dislikes'] =
                                response["data"]["dislikes"];
                            if (dislike) {
                              dislike = false;
                            }
                          });
                        },
                        icon: Icon(
                            like ? Icons.thumb_up : Icons.thumb_up_alt_outlined,
                            size: 22,
                            color: Colors.green),
                        label: Text(
                          widget.post['likesCount'].toString(),
                          style: const TextStyle(
                              color: Colors.black, fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.green),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 95.0,
                      height: 30.0,
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          setState(() {
                            dislike = !dislike;
                          });
                          var response = await dislikePost(widget.post["id"]);
                          print(response);
                          // print(widget.post['likesCount']);
                          setState(() {
                            widget.post['dislikesCount'] =
                                response["data"]["dislikesCount"].toString();
                            widget.post['dislikes'] =
                                response["data"]["dislikes"];
                            widget.post['likesCount'] =
                                response["data"]["likesCount"].toString();
                            widget.post['likes'] = response["data"]["likes"];
                            if (like) {
                              like = false;
                            }
                          });
                        },
                        icon: Icon(
                            dislike
                                ? Icons.thumb_down
                                : Icons.thumb_down_alt_outlined,
                            size: 22,
                            color: Colors.red),
                        label: Text(
                          widget.post['dislikesCount']?.toString() ?? "0",
                          style: const TextStyle(
                              color: Colors.black, fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.red),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 95.0,
                      height: 30.0,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          print('Viewed');
                        },
                        icon: const Icon(Icons.visibility,
                            size: 22, color: Colors.blue),
                        label: Text(
                          widget.post['viewsCount'].toString(),
                          style: const TextStyle(
                              color: Colors.black, fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.blue),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 95.0,
                      height: 30.0,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          print('edit');
                        },
                        icon: const Icon(Icons.edit,
                            size: 22,
                            color: Color.fromARGB(255, 111, 112, 113)),
                        label: const Text(
                          "Edit",
                          style: TextStyle(
                              color: Color.fromARGB(255, 111, 112, 113),
                              fontSize: 11),
                          overflow: TextOverflow.ellipsis,
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                              color: Color.fromARGB(255, 111, 112, 113)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              const Divider(thickness: 0.8),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.post['description'] ?? '',
                  // "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Curabitur pretium tincidunt lacus. Nulla gravida orci a odio. Nullam varius, turpis et commodo pharetra, est eros bibendum elit, nec luctus magna felis sollicitudin mauris. Integer in mauris eu nibh euismod gravida. Duis ac tellus et risus vulputate vehicula. Donec lobortis risus a elit. Etiam tempor. Ut ullamcorper, ligula eu tempor congue, eros est euismod turpis, id tincidunt sapien risus a quam. Maecenas fermentum consequat mi. Donec fermentum. Pellentesque malesuada nulla a mi. Duis sapien sem, aliquet nec, commodo eget, consequat quis, neque. Aliquam faucibus, elit ut dictum aliquet, felis nisl adipiscing sapien, sed malesuada diam lacus eget erat. Cras mollis scelerisque nunc. Nullam arcu. Aliquam consequat. Curabitur augue lorem, dapibus quis, laoreet et, pretium ac, nisi. Aenean magna nisl, mollis quis, molestie eu, feugiat in, orci. In hac habitasse platea dictumst.",
                  style: GoogleFonts.roboto(
                    textStyle: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Divider(
                thickness: 0.8,
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Comments',
                      style: GoogleFonts.roboto(
                          textStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 4, 88, 36),
                      )),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      // controller: commentController,
                      decoration: InputDecoration(
                        hintText: 'Add a comment...',
                        border: OutlineInputBorder(),
                        suffixIcon: IconButton(
                          color: Color.fromARGB(255, 4, 88, 36),
                          icon: Icon(Icons.send),
                          onPressed: () {
                            setState(() {
                              // comments.add(commentController.text);
                              // commentController.clear();
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return const ListTile(
                          leading: CircleAvatar(
                            backgroundImage: AssetImage('assets/nouser.png'),
                            radius: 17,
                            backgroundColor: Colors.transparent,
                          ),
                          title: Text("comments"),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
