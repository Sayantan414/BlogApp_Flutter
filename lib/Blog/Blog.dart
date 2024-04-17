import 'package:blogapp/NetworkHandler.dart';
import 'package:flutter/material.dart';

class Blog extends StatelessWidget {
  const Blog({super.key, required this.networkHandler});

  final NetworkHandler networkHandler;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
            height: 365,
            width: MediaQuery.of(context).size.width,
            child: Card(
              elevation: 8,
              child: Column(
                children: [
                  // Container(
                  //   height: 230,
                  //   width: MediaQuery.of(context).size.width,
                  //   decoration: BoxDecoration(
                  //     image: DecorationImage(
                  //       image: networkHandler.getImage(addBlogModel.id),
                  //       fit: BoxFit.fill,
                  //     ),
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Text(
                      "Hello",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Row(
                      children: [
                        Icon(
                          Icons.chat_bubble,
                          size: 18,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "2".toString(),
                          style: TextStyle(fontSize: 15),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Icon(
                          Icons.thumb_up,
                          size: 18,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          "2".toString(),
                          style: TextStyle(fontSize: 15),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Icon(
                          Icons.share,
                          size: 18,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          "2".toString(),
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Card(
              elevation: 15,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 15,
                ),
                child: Text("gyufvty ftyfytf ftyfty yufgytgfyu"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
