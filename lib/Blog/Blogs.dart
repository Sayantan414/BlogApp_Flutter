import 'package:blogapp/Blog/Blog.dart';
import 'package:blogapp/CustumWidget/BlogCard.dart';

import 'package:blogapp/NetworkHandler.dart';
import 'package:flutter/material.dart';

class Blogs extends StatefulWidget {
  const Blogs({super.key, required this.url});
  final String url;

  @override
  _BlogsState createState() => _BlogsState();
}

class _BlogsState extends State<Blogs> {
  NetworkHandler networkHandler = NetworkHandler();
  dynamic data = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  void fetchData() async {
    print("object");
    var response = await networkHandler.get(widget.url);
    print(response);
    setState(() {
      data = response;
      print(data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return data.length > 0
        ? Column(
            children: data
                .map((item) => Column(
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (contex) => Blog(
                                          networkHandler: networkHandler,
                                        )));
                          },
                          child: BlogCard(
                            data: item,
                            networkHandler: networkHandler,
                          ),
                        ),
                        SizedBox(
                          height: 0,
                        ),
                      ],
                    ))
                .toList(),
          )
        : Center(
            child: Text("We don't have any Blog Yet"),
          );
  }
}
