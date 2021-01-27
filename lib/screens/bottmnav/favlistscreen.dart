import 'package:anime/models/main_model.dart';
import 'package:anime/responsive/responsivehomepage.dart';
import 'package:anime/widgets/listviewcard.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class FavList extends StatefulWidget {
  @override
  _FavListState createState() => _FavListState();
}

class _FavListState extends State<FavList> {
  Map<String, List<String>> verticalImages = {
    'image': [
      'images/attack.jpg',
      'images/conan.jpg',
      'images/death.jpg',
      'images/ds.jpg',
      'images/onepiece.jpg'
    ],
    'title': [
      'Attack On Titan',
      'Conan',
      'Death Note',
      'Demon Slayer',
      'One Piece'
    ]
  };
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    var data = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite List'),
      ),
      body: ScopedModelDescendant(
        builder: (context, child, MainModel animeController) => Container(
          child: animeController.favoriteList.isEmpty
              ? Center(
                  child: Text(
                    'No Favorite Animes',
                    style: TextStyle(fontSize: 20),
                  ),
                )
              : GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, childAspectRatio: responsiveResultGrid(data)),
                  itemCount: animeController.favoriteList.length,
                  itemBuilder: (context, index) {
                    return ListviewCard(
                        width: width,
                        height: height,
                        image: animeController.favoriteList[index].animeImage,
                        title: animeController.favoriteList[index].animeName);
                  }),
        ),
      ),
    );
  }
}
