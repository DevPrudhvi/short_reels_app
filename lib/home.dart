import 'package:btsreels/pages/addvideo.dart';
import 'package:btsreels/pages/messages.dart';
import 'package:btsreels/pages/profile.dart';
import 'package:btsreels/pages/search.dart';
import 'package:btsreels/pages/videos.dart';
import 'package:btsreels/variables.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List pageOptions = [
    Videopage(),
    Searchpage(),
    AddVideoPage(),
    Messages(),
    ProfilePage(),
  ] ;
  int page = 0;

  customIcon() {
    return Container(
      width: 45,
      height: 27,
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(left: 10),
            width: 38,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 250, 45, 108),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: 10),
            width: 38,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 32, 211, 234),
              borderRadius: BorderRadius.circular(7),
            ),
          ),
          Center(
            child: Container(
              height: double.infinity,
              width: 38,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(7),
              ),
              child: Icon(Icons.add, size: 20,),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pageOptions[page],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index){
          setState(() {
            page = index;
          });
        },
        selectedItemColor: Colors.deepPurpleAccent,
        selectedLabelStyle: mystyle(15),
        unselectedItemColor: Colors.black,
        currentIndex: page,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              size: 30,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
              size: 30,
            ),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: customIcon(),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.message,
              size: 30,
            ),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              size: 30,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
