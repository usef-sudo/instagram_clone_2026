import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'BottomNavigationBarPages/add_screen.dart';
import 'BottomNavigationBarPages/favourite_screen.dart';
import 'BottomNavigationBarPages/feed_home_screen.dart';
import 'BottomNavigationBarPages/profile_screen.dart';
import 'BottomNavigationBarPages/search_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  final String userUid;
  HomeScreen(this.userUid, {super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DocumentSnapshot? userDocument;
  bool isLoading = true;

  int _selectedIndex = 0;

  List<Widget> pages = [];
  List<String> pagesTitles = [
    "Home Page",
    "Search Page",
    "Add Page",
    "Favorites Page",
    "Profile Page",
  ];
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    pages =  [
      FeedHomeScreen(),
      SearchScreen(),
      AddScreen(),
      FavouriteScreen(),
      ProfileScreen(widget.userUid)
    ];
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pagesTitles[_selectedIndex]),
        actions: [
          IconButton(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.clear();
                prefs.remove("userUid");
                //
                // Navigator.pushReplacement(context,
                //     MaterialPageRoute(builder: (context) => LoginScreen()));
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: "Add"),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite), label: "Favorites"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: (index) {
          _selectedIndex = index;
          setState(() {});
        },
      ),
    );
  }
}
