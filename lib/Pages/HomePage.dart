import 'package:blogapp/Blog/addBlog.dart';
import 'package:blogapp/Pages/WelcomePage.dart';
import 'package:blogapp/Screen/HomeScreen.dart';
import 'package:blogapp/Profile/ProfileScreen.dart';
import 'package:blogapp/Utils/colors.dart';
import 'package:blogapp/Utils/functions.dart';

import 'package:flutter/material.dart';
import 'package:blogapp/NetworkHandler.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentState = 0;
  List<Widget> widgets = [HomeScreen(), ProfileScreen()];
  List<String> titleString = ["Home Page", "Profile Page"];
  Map<String, dynamic> userDetails = {};

  // late Map<String, dynamic> responseData;

  Widget profilePhoto = Container(
    height: 100,
    width: 100,
    decoration: BoxDecoration(
      color: Colors.black,
      borderRadius: BorderRadius.circular(50),
    ),
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userDetails = getUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(255, 241, 246, 241),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: colorTheme(context)['primary'],
              ),
              child: Column(
                children: <Widget>[
                  CircleAvatar(
                    radius: 48.0,
                    backgroundImage: userDetails['profilePhoto'] != null
                        ? NetworkImage(userDetails['profilePhoto'])
                        : AssetImage('assets/nouser.png') as ImageProvider,
                    backgroundColor: colorTheme(context)['primary'],
                  ),

                  // const CircleAvatar(
                  //   radius: 50,
                  //   backgroundColor: Color.fromARGB(255, 147, 222, 151),
                  //   backgroundImage: AssetImage(
                  //       "https://res.cloudinary.com/djs5memx8/image/upload/v1721902294/blog-api/nrap6pousx3h8hn8d2sc.webp"),
                  // ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    userDetails['fullname'],
                    style: TextStyle(
                      color: colorTheme(context)['text'],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              title: Text("All Post"),
              trailing: Icon(Icons.launch),
              onTap: () {},
            ),
            ListTile(
              title: Text("Settings"),
              trailing: Icon(Icons.settings),
              onTap: () {},
            ),
            ListTile(
              title: Text("Search Profile"),
              trailing: Icon(Icons.search),
              onTap: () {},
            ),
            ListTile(
              title: Text("Logout"),
              trailing: Icon(Icons.power_settings_new),
              onTap: logout,
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: colorTheme(context)['primary'],
        title: Text(
          titleString[currentState],
          style: TextStyle(
            color: colorTheme(context)['text'],
          ),
        ),
        centerTitle: true,
        actions: <Widget>[
          // IconButton(icon: Icon(Icons.search), onPressed: () {}),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: colorTheme(context)['button'],
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AddBlog(action: "Add", data: const {})));
        },
        child: Text(
          "+",
          style: TextStyle(
            fontSize: 40,
            color: colorTheme(context)['buttonText'],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: colorTheme(context)['primary'],
        // shape: CircularNotchedRectangle(),
        notchMargin: 12,
        child: Container(
          height: 60,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.home),
                  color: currentState == 0
                      ? colorTheme(context)['tertiary']
                      : colorTheme(context)['inactiveState'],
                  onPressed: () {
                    setState(() {
                      currentState = 0;
                    });
                  },
                  iconSize: 40,
                ),
                IconButton(
                  icon: Icon(Icons.person),
                  color: currentState == 1
                      ? colorTheme(context)['tertiary']
                      : colorTheme(context)["inactiveState"],
                  onPressed: () {
                    setState(() {
                      currentState = 1;
                    });
                  },
                  iconSize: 40,
                )
              ],
            ),
          ),
        ),
      ),
      body: widgets[currentState],
    );
  }

  void logout() async {
    // await storage.delete(key: "token");
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => WelcomePage()),
        (route) => false);
  }
}
