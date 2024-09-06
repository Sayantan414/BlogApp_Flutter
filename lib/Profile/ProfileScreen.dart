import 'package:blogapp/Blog/Blogs.dart';
import 'package:blogapp/NetworkHandler.dart';
import 'package:blogapp/Profile/CreateProfile.dart';
import 'package:blogapp/Services/userService.dart';
import 'package:blogapp/Utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool circular = false;
  NetworkHandler networkHandler = NetworkHandler();
  List<dynamic> data = [];
  bool isLoading = true;
  String dp = '';
  Map<String, dynamic> profileDetails = {};
  late Map<String, dynamic> responseData;
  String medal = '';

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    try {
      circular = true;
      var responseData = await profile();
      profileDetails = responseData;
      // print(profileDetails);
      if (profileDetails['userAward'] == "Bronze") {
        setState(() {
          medal = '🥉';
        });
      } else if (profileDetails['userAward'] == "Silver") {
        setState(() {
          medal = '🥈';
        });
      } else {
        setState(() {
          medal = '🥇';
        });
      }
      setState(() {
        data = profileDetails['posts'];
        circular = false;
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorTheme(context)['primary'],
      appBar: AppBar(
        backgroundColor: colorTheme(context)['primary'],
        elevation: 0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(
                      builder: (context) => CreateProfile(type: "Edit")))
                  .then((value) => setState(() {
                        if (value['update'] == true) {
                          fetchData();
                        }
                      }));
            },
            color: colorTheme(context)['button'],
          ),
        ],
      ),
      body: circular
          ? Center(
              child: CircularProgressIndicator(
              value: null,
              valueColor: AlwaysStoppedAnimation<Color>(
                colorTheme(context)['loader'],
              ), // Color of the progress indicator
            ))
          : ListView(
              children: <Widget>[
                Center(child: head()),
                SizedBox(
                  height: 8,
                ), // Center the head widget
                // Divider(
                //   thickness: 0.8,
                // ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 4.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildCard(
                          "Followers",
                          profileDetails['followersCount'].toString(),
                          Color.fromARGB(255, 34, 139, 34), // Forest Green
                          Color.fromARGB(255, 60, 179,
                              113), // Slightly lighter shade of green
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _buildCard(
                          "Following",
                          profileDetails['followingCount'].toString(),
                          Color.fromARGB(255, 0, 0, 205), // Medium Blue
                          Color.fromARGB(255, 70, 130,
                              180), // Slightly lighter shade of blue
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildCard(
                          "Viewers",
                          profileDetails['viewersCount'].toString(),
                          Color.fromARGB(255, 255, 140, 0), // Dark Orange
                          Color.fromARGB(255, 255, 165,
                              0), // Slightly lighter shade of orange
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _buildCard(
                          "No. of Posts",
                          profileDetails['postCounts'].toString(),
                          Color.fromARGB(255, 128, 0, 128), // Purple
                          Color.fromARGB(255, 147, 112,
                              219), // Slightly lighter shade of purple
                        ),
                      ),
                    ],
                  ),
                ),

                const Divider(
                  thickness: 0.8,
                ),
                const SizedBox(
                  height: 20,
                ),
                data.isNotEmpty ? Blogs(type: "Own", posts: data) : _noData(),
              ],
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

  Widget head() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.center, // Center content within the column
        children: <Widget>[
          Stack(
            alignment:
                Alignment.center, // Align the icon to the center of the Stack
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Color.fromARGB(255, 225, 235, 225),
                backgroundImage: profileDetails['profilePhoto'] != null
                    ? NetworkImage(profileDetails['profilePhoto'])
                    : AssetImage('assets/nouser.png') as ImageProvider,
              ),
              Positioned(
                bottom: 0, // Position the emoji at the bottom
                right: -7, // Position the emoji to the right
                child: Text(
                  medal, // Medal emoji
                  style: TextStyle(
                    fontSize: 30, // Size of the emoji
                    color: Colors.amber, // Color of the emoji
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10), // Add space between avatar and text
          Text(
            profileDetails['fullname'],
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: colorTheme(context)['text'],
            ),
          ),
          const SizedBox(height: 10), // Add space between texts
          Text(
            "titleLine",
            style: TextStyle(
              color: colorTheme(context)['text'],
            ),
          ),
        ],
      ),
    );
  }

  Widget otherDetails(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "$label :",
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 15),
          )
        ],
      ),
    );
  }

  Widget _buildCard(String title, String count, Color dark, Color light) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            dark,
            light,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 5.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            Text(
              count,
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    blurRadius: 3.0,
                    color: Color.fromARGB(116, 255, 255, 255),
                    offset: Offset(2.0, 2.0),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
