import 'package:anime/widgets/signbutton.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  File image;
  ImagePicker imagePicker = ImagePicker();
  String defaultImage =
      'https://images.squarespace-cdn.com/content/54b7b93ce4b0a3e130d5d232/1519987165674-QZAGZHQWHWV8OXFW6KRT/icon.png?content-type=image%2Fpng';
  String email;

  @override
  void initState() {
    super.initState();
    getEmailString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Container(
        margin: const EdgeInsets.all(8),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CircleAvatar(
                  foregroundColor: Colors.blueGrey,
                  radius: 60,
                  backgroundImage: image != null
                      ? FileImage(image)
                      : NetworkImage(defaultImage),
                  child: IconButton(
                    icon: Icon(Icons.file_upload),
                    onPressed: () {
                      showDialog(
                        context: (context),
                        builder: (context) => AlertDialog(
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              FlatButton(
                                  onPressed: () {
                                    getImage(ImageSource.camera);
                                    Navigator.pop(context);
                                  },
                                  child: Text('Take photo')),
                              FlatButton(
                                  onPressed: () {
                                    getImage(ImageSource.gallery);
                                    Navigator.pop(context);
                                  },
                                  child: Text('Choose existing'))
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Column(
                  children: [
                    Text('Your name'),
                    Text('Your Settings'),
                  ],
                )
              ],
            ),
            buildContainer(email == null ? 'Your Email' : email, Icons.email),
            buildContainer('Your Password', Icons.lock),
            buildContainer('Your Birthdate', Icons.calendar_today),
            buildContainer('Your Language', Icons.language),
            SignButton('Log out', () async {
              SharedPreferences sharedPreferences =
                  await SharedPreferences.getInstance();
              sharedPreferences.clear();
            })
          ],
        ),
      ),
    );
  }

  getEmailString() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String stringValue = sharedPreferences.getString('email');
    setState(() {
      email = stringValue;
    });
  }

  getImage(ImageSource imageSource) async {
    PickedFile file = await imagePicker.getImage(source: imageSource);
    setState(() {
      image = File(file.path);
    });
  }

  Widget buildContainer(String title, IconData iconData) {
    return Container(
      margin: const EdgeInsets.only(top: 28, bottom: 4),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.blueGrey),
          borderRadius: BorderRadius.circular(20)),
      child: ListTile(
        title: Text(title),
        trailing: Icon(Icons.edit),
        leading: Icon(iconData),
      ),
    );
  }
}
