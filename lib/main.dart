import 'package:flutter/material.dart';
import './Pages/homepage.dart';
import './Pages/drawer_page.dart';

void main() {
  runApp(
    MaterialApp(
      title: " ",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        indicatorColor: Colors.black,
        primaryColor: Color(0xff222B45),
        fontFamily: "BalooTamma",
      ),
      home: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          DrawerScreen(),
          HomePage(),
        ],
      ),
    );
  }
}
