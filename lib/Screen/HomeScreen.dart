import 'package:blogapp/Blog/Blogs.dart';
import 'package:blogapp/Services/postService.dart';
import 'package:blogapp/Utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> data = [];
  bool isLoading = true;
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

        isLoading = false;
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorTheme(context)['primary'],
      body: SingleChildScrollView(
        child: Container(
          child:
              data.isNotEmpty ? Blogs(type: "Public", posts: data) : _noData(),
        ),
      ),
    );
  }

  Widget _noData() {
    return Center(
      child: isLoading
          ? LoadingAnimationWidget.fourRotatingDots(
              color: colorTheme(context)['tertiary'],
              size: 50,
            )
          : const Column(
              mainAxisAlignment: MainAxisAlignment.center, // Center vertically
              children: [
                SizedBox(height: 20),
                Text(
                  "We don't have any Blog Yet",
                  style: TextStyle(
                      // color: myColors["desabled"],
                      ),
                ),
              ],
            ),
    );
  }
}
