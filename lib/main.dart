import 'package:anime/models/anime/anime_controller.dart';
import 'package:anime/models/main_model.dart';
import 'package:anime/screens/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel(
      model: MainModel(),
          child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          appBarTheme: AppBarTheme(
            elevation: 0,
            centerTitle: true,
            textTheme: TextTheme(
                title: TextStyle(
                    letterSpacing: 4, fontSize: 18, fontWeight: FontWeight.bold)),
          ),
        ),
        home: SplashScreens(),
      ),
    );
  }
}
