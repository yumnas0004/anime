import 'package:anime/models/main_model.dart';
import 'package:anime/responsive/responsivehomepage.dart';
import 'package:anime/screens/searchscreen.dart';
import 'package:anime/widgets/listviewcard.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class HomePage extends StatefulWidget {
  final MainModel mainModelController;
  HomePage(this.mainModelController);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    widget.mainModelController.getAnime();
    widget.mainModelController.getCategories();
  }

  List<String> horizontalImages = [
    'images/deathnote.jpg',
    'images/demonSlayer.png',
    'images/myheroacademia.jpg',
    'images/na.jpeg',
    'images/one.jpg'
  ];

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    var data = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('My Anime'),
        actions: [
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Search('Search', widget.mainModelController)),);
              })
        ],
      ),
      body: Container(
        child: ListView(children: [
          ScopedModelDescendant(
            builder: (context, child, MainModel category) => Container(
              height: height * .05,
              margin: const EdgeInsets.all(10),
              child: category.isGetCategoriesLoading == true
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(category.allCategories[0].categoryName),
                        Text(category.allCategories[1].categoryName),
                        Text(category.allCategories[2].categoryName),
                      ]
                    ),
            ),
          ),
          Container(
            height: height * 0.3,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: horizontalImages.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.all(8),
                  width: width * 0.7,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(
                          image: AssetImage(horizontalImages[index]),
                          fit: BoxFit.fill)),
                );
              },
            ),
          ),
          buildListTile('New Animes' , widget.mainModelController),
          Container(
            height: responsiveHomePageContainer(data),
            child: listviewMethod(width, height),
          ),
          buildListTile('Popular Animes' , widget.mainModelController),
          Container(
            height: responsiveHomePageContainer(data),
            child: listviewMethod(width, height),
          ),
        ]),
      ),
    );
  }

  listviewMethod(double width, double height) {
    return ScopedModelDescendant(
      builder: (context, child, MainModel anime) {
        if (anime.isGetAnimeLoading == true) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (anime.animeList.isEmpty) {
          return Center(
              child: Text(
            'No anime found',
            style: TextStyle(fontSize: 25),
          ));
        } else {
          return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: anime.animeList.length,
              itemBuilder: (context, index) {
                return ListviewCard(
                    id: anime.animeList[index].animeId,
                    width: width,
                    height: height,
                    image: anime.animeList[index].animeImage,
                    title: anime.animeList[index].animeName,
                    duration: anime.animeList[index].animeDuration,
                    views: anime.animeList[index].animeViews,
                    genre: anime.animeList[index].animeGenre,
                    publishedDate: anime.animeList[index].publishedDate);
              });
        }
      },
    );
  }

  buildListTile(String title , MainModel mainModel) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(fontSize: 16.5, fontWeight: FontWeight.bold),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: Colors.black,
      ),
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Search(title , mainModel )));
      },
    );
  }
}
