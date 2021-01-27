import 'package:anime/screens/bottmnav/bottomnavbar.dart';
import 'package:anime/widgets/signbutton.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> emailKey = GlobalKey<FormState>();
  GlobalKey<FormState> passwordKey = GlobalKey<FormState>();

  final _formKey = GlobalKey<FormState>();

  bool isPressed = true;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        children: [
          signInField('Enter your email', Icons.email,
              TextInputType.emailAddress, emailController, emailKey),
          signInField('Enter your password', Icons.lock, TextInputType.number,
              passwordController, passwordKey),
          SignButton(
            'Login',
            () async {
              if (!_formKey.currentState.validate()) {
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Some fields required'),
                    duration: Duration(seconds: 5),
                  ),
                );
              } else {
                SharedPreferences sharedPreferences =
                    await SharedPreferences.getInstance();
                sharedPreferences.setString('email', emailController.text);
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => BottomNavBar()));
              }
            },
          )
        ],
      ),
    );
  }

  signInField(String labelText, IconData icon, TextInputType keyboardType,
      TextEditingController controller, Key key) {
    return Container(
      margin: const EdgeInsets.only(top: 40, left: 10, right: 10),
      child: TextFormField(
        validator: (val) => val.isEmpty ? 'Some fields required' : null,
        obscureText: labelText == 'Enter your password' ? isPressed : false,
        controller: controller,
        key: key,
        keyboardType: keyboardType,
        decoration: InputDecoration(
            prefixIcon: Icon(icon),
            labelText: labelText,
            suffixIcon: labelText == 'Enter your password'
                ? IconButton(
                    icon: Icon(Icons.remove_red_eye),
                    onPressed: () {
                      setState(() {
                        isPressed = !isPressed;
                      });
                    },
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
            )),
      ),
    );
  }
}
