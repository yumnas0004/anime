import 'package:anime/models/main_model.dart';
import 'package:anime/responsive/responsivehomepage.dart';
import 'package:anime/widgets/listviewcard.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class Search extends StatefulWidget {

final MainModel anime;
final String title;

Search(this.title, this.anime);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {

@override
void initState() {
  widget.anime.getAnime();
  super.initState();
}

  @override
  Widget build(BuildContext context) {
    var data = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          '${widget.title}',
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            return Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        margin: EdgeInsets.all(10.0),
        child: ScopedModelDescendant(
          builder: (context, child, MainModel anime){
            if(anime.isGetAnimeLoading == true){
              return Center(child: CircularProgressIndicator());
            }else if(anime.animeList.isEmpty){
              return Center(child: Text('no movie found', style: TextStyle(fontSize: 30.0)));
            }else{
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 5,
                  childAspectRatio: responsiveResultGrid(data)
                ),
                scrollDirection: Axis.vertical,
                itemCount: anime.animeList.length,
                itemBuilder: (context, index){
                  return ListviewCard(
                    width: data.size.width,
                    height: data.size.height,
                    image : anime.animeList[index].animeImage,
                    duration: anime.animeList[index].animeDuration,
                    title:anime.animeList[index].animeName,
                    genre: anime.animeList[index].animeGenre,
                    publishedDate: anime.animeList[index].publishedDate,
                  );
                },
              );
            }
          }
        ),
      ),
    );
  }
}