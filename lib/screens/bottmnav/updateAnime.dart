import 'package:anime/models/main_model.dart';
import 'package:anime/widgets/signbutton.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class UpdateAnime extends StatefulWidget {
  final String animeId;
  final String animeName;
  final double animeDuration;
  UpdateAnime({this.animeId, this.animeName, this.animeDuration});
  @override
  _UpdateAnimeState createState() => _UpdateAnimeState();
}

class _UpdateAnimeState extends State<UpdateAnime> {
  TextEditingController titleController = TextEditingController();
  TextEditingController durationController = TextEditingController();
  final GlobalKey<FormFieldState<String>> nameKey =
      GlobalKey<FormFieldState<String>>();
  final GlobalKey<FormFieldState<String>> durationKey =
      GlobalKey<FormFieldState<String>>();

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Anime'),
      ),
      body: ScopedModelDescendant(
        builder: (context, child, MainModel updateController) => Container(
          margin: const EdgeInsets.all(10),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                field(widget.animeName, TextInputType.name, titleController,
                    nameKey),
                field(widget.animeDuration.toString(), TextInputType.number,
                    durationController, durationKey),
                SignButton('Update', () async {
                  bool _valid = await updateController.updateAnime(
                      id: widget.animeId,
                      animeName: titleController.text.isEmpty ? widget.animeName : titleController.text,
                      animeDuration:durationController.text.isEmpty ? widget.animeDuration : double.parse(durationController.text));
                  if (_valid == true) {
                    return Scaffold.of(context)
                        .showSnackBar(snack('Anime Updated'));
                  } else {
                    return Scaffold.of(context)
                        .showSnackBar(snack('Something went wrong'));
                  }
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  field(String hint, TextInputType inputType, TextEditingController controller,
      Key key) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      margin: EdgeInsets.all(10.0),
      elevation: 3.0,
      child: TextFormField(
        key: key,
        validator: (value) {
          if (value.isEmpty) {
            return 'this field requred!';
          }
        },
        decoration: InputDecoration(
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: BorderSide(color: Colors.red, width: 1.0),
          ),
          hintText: hint,
          contentPadding: const EdgeInsets.all(10),
          labelStyle: TextStyle(
              color: Colors.grey,
              fontSize: 15.0,
              fontWeight: FontWeight.normal),
        ),
        keyboardType: inputType,
        controller: controller,
      ),
    );
  }

  snack(String content) {
    return SnackBar(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0))),
      duration: Duration(seconds: 2),
      content: Text(content,
          style: TextStyle(
              color: Colors.white,
              fontSize: 15.0,
              fontWeight: FontWeight.normal)),
      backgroundColor: Colors.deepPurple,
    );
  }
}
