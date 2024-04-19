import 'package:flutter/material.dart';

class OverlayCard extends StatelessWidget {
  final String title;
  final String body;

  const OverlayCard({super.key, required this.body, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      padding: EdgeInsets.all(5),
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(height: 10), // Add some gap at the top
          // Expanded(
          //   child: Container(
          //     decoration: BoxDecoration(
          //       image: DecorationImage(
          //         image: FileImage(
          //           File(imagefile.path),
          //         ),
          //         fit: BoxFit.cover, // Fit the image to cover the container
          //       ),
          //       borderRadius: BorderRadius.circular(8),
          //     ),
          //   ),
          // ),
          Container(
            padding: EdgeInsets.all(8),
            height: 55,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 255, 255, 255),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
            ),
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
