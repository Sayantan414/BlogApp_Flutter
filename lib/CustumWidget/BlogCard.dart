import 'package:blogapp/NetworkHandler.dart';
import 'package:flutter/material.dart';

class BlogCard extends StatelessWidget {
  const BlogCard({super.key, required this.data, required this.networkHandler});

  final NetworkHandler networkHandler;
  final List<dynamic> data;

  @override
  Widget build(BuildContext context) {
    print(data);
    return Container(
      height: 280,
      padding: EdgeInsets.symmetric(horizontal: 13, vertical: 8),
      width: MediaQuery.of(context).size.width,
      child: Card(
        child: Stack(
          children: <Widget>[
            // Container(
            //   height: MediaQuery.of(context).size.height,
            //   width: MediaQuery.of(context).size.width,
            //   decoration: BoxDecoration(
            //     image: DecorationImage(
            //         image: networkHandler.getImage(addBlogModel.id),
            //         fit: BoxFit.fill),
            //   ),
            // ),
            Positioned(
              bottom: 2,
              child: Container(
                padding: EdgeInsets.all(7),
                height: 60,
                width: MediaQuery.of(context).size.width - 30,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8)),
                child: Text(
                  "hello",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
