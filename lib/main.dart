// import 'package:blogapp/Pages/HomePage.dart';
import 'package:blogapp/Pages/WelcomePage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget page = WelcomePage();
  // final storage = FlutterSecureStorage();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkLogin();
  }

  void checkLogin() async {
    // String? token = await storage.read(key: "token");
    // if (token != null) {
    //   setState(() {
    //     page = HomePage();
    //   });
    // } else {
    setState(() {
      page = WelcomePage();
    });
    // }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode
          .system, // Change to ThemeMode.light or ThemeMode.dark as needed
      theme: ThemeData(
        brightness: Brightness.light,
        textTheme: GoogleFonts.openSansTextTheme(),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        textTheme: GoogleFonts.openSansTextTheme(),
      ),
      home: WelcomePage(),
    );
  }
}
