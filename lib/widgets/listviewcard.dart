import 'package:anime/models/main_model.dart';
import 'package:anime/screens/bottmnav/updateAnime.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class ListviewCard extends StatefulWidget {
  const ListviewCard(
      {@required this.width,
      @required this.height,
      @required this.image,
      @required this.title,
      this.publishedDate,
      this.genre,
      this.duration,
      this.views,
      this.id});

  final double width;
  final double height;
  final String image;
  final String title;
  final double duration;
  final int views;
  final String genre;
  final String publishedDate;
  final String id;

  @override
  _ListviewCardState createState() => _ListviewCardState();
}

class _ListviewCardState extends State<ListviewCard> {
  bool isPressed = false;
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
      builder: (context, child, MainModel animeController) => InkWell(
        onTap: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FlatButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UpdateAnime(
                                          animeId: widget.id,
                                          animeName: widget.title,
                                          animeDuration: widget.duration,
                                        )));
                          },
                          child: Text(
                            'Update',
                            style: TextStyle(fontSize: 18),
                          )),
                      FlatButton(
                          hoverColor: Colors.red[400],
                          onPressed: () {
                            animeController.selectMovie(widget.id);
                            animeController.deleteAnime(widget.id);
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Delete',
                            style: TextStyle(color: Colors.red, fontSize: 18),
                          )),
                    ],
                  ),
                );
              });
        },
        child: Container(
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
          ),
          width: widget.width * 0.45,
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(8),
                height: widget.height * .3,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(
                      image: widget.image == null
                          ? AssetImage('images/ds.jpg')
                          : NetworkImage(widget.image),
                      fit: BoxFit.fill),
                ),
              ),
              ListTile(
                title: Text(
                  widget.title,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                    '${widget.publishedDate} - ${widget.genre} - ${widget.duration} min'),
                trailing: IconButton(
                  icon: Icon(
                    isPressed == true ? Icons.favorite : Icons.favorite_border,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    setState(() {
                      animeController.addToFavorite(widget.id);
                      isPressed = !isPressed;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
