import 'package:anime/models/anime/anime_controller.dart';
import 'package:anime/models/main_model.dart';
import 'package:anime/widgets/signbutton.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:scoped_model/scoped_model.dart';

class AddAnime extends StatefulWidget {
  @override
  _AddAnimeState createState() => _AddAnimeState();
}

class _AddAnimeState extends State<AddAnime> {
  File image;
  ImagePicker imagePicker = ImagePicker();

  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  final GlobalKey<FormFieldState<String>> nameKey =
      GlobalKey<FormFieldState<String>>();
  final GlobalKey<FormFieldState<String>> priceKey =
      GlobalKey<FormFieldState<String>>();
  final GlobalKey<FormFieldState<String>> descriptionKey =
      GlobalKey<FormFieldState<String>>();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Add Anime'),
        ),
        body: ScopedModelDescendant(
            builder: (context, child, MainModel anime) {
          return Container(
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  Container(
                    margin: const EdgeInsets.all(10),
                    height: MediaQuery.of(context).size.height * .4,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: image == null
                                ? AssetImage('images/logo.png')
                                : FileImage(image),
                            fit: BoxFit.fill)),
                    alignment: Alignment.bottomRight,
                    child: IconButton(
                        icon: Icon(Icons.add_a_photo),
                        color: Colors.black,
                        iconSize: 35.0,
                        onPressed: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return Container(
                                  height:
                                      MediaQuery.of(context).size.height * .3,
                                  margin: const EdgeInsets.all(20),
                                  child: Column(
                                    children: [
                                      Text(
                                        'Upload Image',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      ListTile(
                                        title: Text(
                                          'Camera',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        trailing: Icon(Icons.camera,
                                            color: Colors.deepPurple,
                                            size: 25.0),
                                        onTap: () {
                                          getImage(ImageSource.camera);
                                        },
                                      ),
                                      ListTile(
                                        title: Text(
                                          'Gallery',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        trailing: Icon(Icons.camera,
                                            color: Colors.deepPurple,
                                            size: 25.0),
                                        onTap: () {
                                          getImage(ImageSource.gallery);
                                        },
                                      )
                                    ],
                                  ),
                                );
                              });
                        }),
                  ),
                  field('Movie Name', TextInputType.text, nameController,
                      nameKey),
                  field('Movie Duration', TextInputType.number, priceController,
                      priceKey),
                  SignButton('Add', () async {
                    if (!_formKey.currentState.validate()) {
                      return Scaffold.of(context)
                          .showSnackBar(snack('someFieldsRequired'));
                    } else {
                      bool _valid = await anime.addAnime(nameController.text, double.parse(priceController.text ));
                      if(_valid == true){
                        return Scaffold.of(context).showSnackBar(snack('movie added'));
                      }else{
                        return Scaffold.of(context).showSnackBar(snack('something went wrong'));
                      }
                    }
                  })
                ],
              ),
            ),
          );
        }));
  }

  field(String label, TextInputType inputType, TextEditingController controller,
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
          labelText: label,
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

  getImage(ImageSource imageSource) async {
    PickedFile _file = await imagePicker.getImage(source: imageSource);
    if (_file != null) {
      setState(() {
        image = File(_file.path);
      });
    } else {
      return null;
    }
  }
}
