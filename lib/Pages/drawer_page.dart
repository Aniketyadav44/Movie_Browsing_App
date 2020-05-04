import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import './contact.dart';
import './search_page.dart';

class DrawerScreen extends StatefulWidget {
  @override
  _DrawerScreenState createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.cyan),
      child: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.2,
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  "MOVIE TIME",
                  style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context,MaterialPageRoute(builder: (context){
                  return queryData();
                }));
              },
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Icon(
                      FontAwesome5Solid.search,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  Text(
                    "SEARCH MOVIES",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 22),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return Contact();
                    },
                  ),
                );
              },
              child: Row(
                children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Icon(
                        FontAwesome5Solid.laptop_code,
                        size: 30,
                        color: Colors.white,
                      )),
                  Text(
                    "CONTACT",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 22),
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
