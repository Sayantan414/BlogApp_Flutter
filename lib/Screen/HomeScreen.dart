import 'package:blogapp/Blog/Blogs.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isSearching = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(98, 197, 222, 184),
      // appBar: AppBar(
      //   backgroundColor: Color.fromARGB(97, 206, 224, 197),
      //   automaticallyImplyLeading: false, // Removes the back button
      //   actions: [
      //     _isSearching
      //         ? Expanded(
      //             child: Row(
      //               children: [
      //                 Expanded(
      //                   child: Padding(
      //                     padding: const EdgeInsets.only(left: 10.0),
      //                     child: TextField(
      //                       decoration: InputDecoration(
      //                         hintText: 'Search...',
      //                         border: InputBorder.none,
      //                       ),
      //                       autofocus: true,
      //                       textInputAction: TextInputAction.search,
      //                       onSubmitted: (value) {
      //                         // Perform search here with value
      //                       },
      //                     ),
      //                   ),
      //                 ),
      //                 IconButton(
      //                   icon: Icon(Icons.cancel),
      //                   onPressed: () {
      //                     setState(() {
      //                       _isSearching = false;
      //                     });
      //                   },
      //                 ),
      //               ],
      //             ),
      //           )
      //         : IconButton(
      //             icon: Icon(Icons.search),
      //             onPressed: () {
      //               setState(() {
      //                 _isSearching = true;
      //               });
      //             },
      //           ),
      //   ],
      // ),
      body: SingleChildScrollView(
        child: Blogs(url: "/blogpost/getOtherBlog", type: "Public"),
      ),
    );
  }
}
