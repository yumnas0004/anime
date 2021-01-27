import 'package:flutter/material.dart';

class SignButton extends StatelessWidget {
  final String text;
  final Function onPressed;

  SignButton(this.text , this.onPressed);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 8, right: 8 , bottom: 20),
      child: FlatButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
        padding: const EdgeInsets.all(10),
        color: Colors.deepPurple,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}
