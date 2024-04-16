import 'package:blogapp/Blog/addBlog.dart';
import 'package:blogapp/Pages/WelcomePage.dart';
import 'package:blogapp/Screen/HomeScreen.dart';
import 'package:blogapp/Profile/ProfileScreen.dart';

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
  // final storage = FlutterSecureStorage();
  NetworkHandler networkHandler = NetworkHandler();
  String? username = "";
  late Map<String, dynamic> responseData;

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
    checkProfile();
  }

  void checkProfile() async {
    try {
      var response = await networkHandler.get("/profile/checkProfile");
      print(response);
      bool status = response["status"];
      print(status);
      if (status == true) {
        setState(() {
          fetchData();
        });
      } else {
        setState(() {
          profilePhoto = Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(50),
            ),
          );
        });
      }
    } catch (e) {
      profilePhoto = Container(
        height: 100,
        width: 100,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(50),
        ),
      );
    }
  }

  void fetchData() async {
    try {
      var response = await networkHandler.get("/profile/getData");
      if (response != null && response["data"] != null) {
        responseData = response["data"];
        print(responseData);
        setState(() {
          profilePhoto = CircleAvatar(
            radius: 50,
            backgroundImage:
                NetworkHandler().getImage(responseData['username']),
          );
        });
      } else {
        print("Response is null or doesn't contain data");
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 147, 222, 151),
              ),
              child: Column(
                children: <Widget>[
                  profilePhoto,
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    responseData['name'],
                    style: TextStyle(
                      color: Colors.white,
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
              title: Text("New Story"),
              trailing: Icon(Icons.add),
              onTap: () {},
            ),
            ListTile(
              title: Text("Settings"),
              trailing: Icon(Icons.settings),
              onTap: () {},
            ),
            ListTile(
              title: Text("Feedback"),
              trailing: Icon(Icons.feedback),
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
        backgroundColor: Color.fromARGB(255, 147, 222, 151),
        title: Text(titleString[currentState]),
        centerTitle: true,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.notifications), onPressed: () {}),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 147, 222, 151),
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AddBlog()));
        },
        child: const Text(
          "+",
          style: TextStyle(fontSize: 40),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Color.fromARGB(255, 147, 222, 151),
        shape: CircularNotchedRectangle(),
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
                  color: currentState == 0 ? Colors.white : Colors.white54,
                  onPressed: () {
                    setState(() {
                      currentState = 0;
                    });
                  },
                  iconSize: 40,
                ),
                IconButton(
                  icon: Icon(Icons.person),
                  color: currentState == 1 ? Colors.white : Colors.white54,
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
