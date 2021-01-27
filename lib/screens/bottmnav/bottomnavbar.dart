import 'package:anime/models/anime/anime_controller.dart';
import 'package:anime/models/main_model.dart';
import 'package:anime/screens/bottmnav/addAnime.dart';
import 'package:anime/screens/bottmnav/favlistscreen.dart';
import 'package:anime/screens/bottmnav/homepagescreen.dart';
import 'package:anime/screens/bottmnav/profilescreen.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.deepPurple,
          selectedItemColor: Colors.white,
          selectedFontSize: 16,
          iconSize: 28,
          currentIndex: currentIndex,
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.favorite), label: 'Favorite List'),
            BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Add Anime'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'profile'),
          ]),
      body: ScopedModelDescendant(
          builder: (context, child, MainModel anime) {
        return navigate(anime);
      }),
    );
  }

  navigate(MainModel animeController) {
    if (currentIndex == 0) {
      return HomePage(animeController);
    } else if (currentIndex == 1) {
      return FavList();
    } else if (currentIndex == 2) {
      return AddAnime();
    } else if (currentIndex == 3) {
      return Profile();
    }
  }
}
