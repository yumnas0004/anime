import 'package:anime/screens/bottmnav/bottomnavbar.dart';
import 'package:anime/widgets/signbutton.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  TextEditingController _userameController = TextEditingController();
  TextEditingController _adressController = TextEditingController();
  GlobalKey<FormState> usernameKey = GlobalKey<FormState>();
  GlobalKey<FormState> adressKey = GlobalKey<FormState>();
  GlobalKey<FormState> emailKey = GlobalKey<FormState>();
  GlobalKey<FormState> passwordKey = GlobalKey<FormState>();
  GlobalKey<FormState> confirmPasswordKey = GlobalKey<FormState>();

  bool secure = true;
  bool checkBox = false;
  String gender = 'Select gender';
  DateTime dateTime;
  String subtitle = 'maybe?';
  bool _isMapLoading = true;
  Position position;
  Location location;
  List<Marker> markers = [];
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    checkPermissionsAndGetLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        children: [
          signUpField('Enter your user name', Icons.person, TextInputType.name,
              _userameController, usernameKey, false, null),
          signUpField(
              'Enter your email',
              Icons.email,
              TextInputType.emailAddress,
              _emailController,
              emailKey,
              false,
              null),
          signUpField('Enter your password', Icons.lock, TextInputType.number,
              _passwordController, passwordKey, secure, lockIcon()),
          signUpField(
              'Confirm your password',
              Icons.lock,
              TextInputType.number,
              _confirmPasswordController,
              confirmPasswordKey,
              secure,
              lockIcon()),
          signUpField(
              'Enter your adress',
              Icons.location_on,
              TextInputType.streetAddress,
              _adressController,
              adressKey,
              false,
              null),
          Container(
            height: MediaQuery.of(context).size.height * .3,
            margin: const EdgeInsets.all(10),
            child: _isMapLoading == true
                ? Center(child: CircularProgressIndicator())
                : locationContainer(),
          ),
          otherFields(
              'Gender',
              gender,
              PopupMenuButton(
                  icon: Icon(
                    Icons.arrow_drop_down,
                    size: 25,
                  ),
                  onSelected: (val) {
                    setState(() {
                      gender = val;
                    });
                  },
                  itemBuilder: (BuildContext ctx) {
                    return [
                      PopupMenuItem(
                        child: Text('Female'),
                        value: 'Female',
                      ),
                      PopupMenuItem(
                        child: Text('Male'),
                        value: 'Male',
                      )
                    ];
                  }),
              () {}),
          otherFields(
              'Terms & Condtions',
              'Read our Terms & Condtions',
              Checkbox(
                  activeColor: Colors.deepPurple,
                  value: checkBox,
                  onChanged: (val) {
                    setState(() {
                      checkBox = val;
                    });
                  }), () {
            showBottomSheet(
                context: context,
                builder: (BuildContext ctx) {
                  return Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        border:
                            Border.all(color: Colors.deepPurple, width: 1.5),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        )),
                    child: Container(
                      height: MediaQuery.of(context).size.height * .4,
                      child: ListTile(
                        title: Text('Terms & Condtions'),
                        subtitle: Text('blablablabla'),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  );
                });
          }),
          otherFields(
              'Select your birthdate',
              dateTime == null
                  ? 'No Date Chosen'
                  : DateFormat.yMMMd().format(dateTime),
              Icon(Icons.calendar_today), () {
            showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2022))
                .then((value) {
              if (value != null) {
                setState(() {
                  dateTime = value;
                });
              }
              print('Something happend');
            });
          }),
          otherFields(
              'Are you sure?',
              subtitle,
              Icon(
                Icons.arrow_drop_down,
                size: 25,
              ), () {
            showDialog(
                context: context,
                builder: (BuildContext ctx) {
                  return AlertDialog(
                    content: Text('Sure you want to sign up?'),
                    actions: [
                      dialogButton(context, 'Yes'),
                      dialogButton(context, 'No'),
                    ],
                  );
                });
          }),
          SignButton(
            'Sign up',
            () {
              if (!_formKey.currentState.validate()) {
                Scaffold.of(context).showSnackBar(
                  snackBar('Some fields required'),
                );
              } else if (_passwordController.text !=
                  _confirmPasswordController.text) {
                Scaffold.of(context).showSnackBar(
                  snackBar('Password don\'t match'),
                );
              } else if (gender == 'Select gender') {
                Scaffold.of(context).showSnackBar(
                  snackBar('Select your gender'),
                );
              } else if (checkBox == false) {
                Scaffold.of(context).showSnackBar(
                  snackBar('Accept the Terms & Condtions'),
                );
              } else if (subtitle != 'Yes') {
                Scaffold.of(context).showSnackBar(
                  snackBar('Make sure to select Yes'),
                );
              } else {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => BottomNavBar()));
              }
            },
          ),
        ],
      ),
    );
  }

  dialogButton(BuildContext context, String text) {
    return FlatButton(
        onPressed: () {
          setState(() {
            subtitle = text;
            Navigator.pop(context);
          });
        },
        child: Text(text));
  }

  otherFields(String title, String subtitle, Widget trailing, Function onTap) {
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 10, right: 10),
      decoration: BoxDecoration(
          border: Border.all(), borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }

  snackBar(String content) {
    return SnackBar(
      content: Text(content),
      duration: Duration(seconds: 5),
    );
  }

  lockIcon() {
    return IconButton(
      icon: Icon(Icons.remove_red_eye),
      onPressed: () {
        setState(() {
          secure = !secure;
        });
      },
    );
  }

  signUpField(String labelText, IconData icon, TextInputType keyboardType,
      TextEditingController controller, Key key, bool secure, Widget lockIcon) {
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 10, right: 10),
      child: TextFormField(
        validator: (val) => val.isEmpty ? 'Some fields required' : null,
        obscureText: secure,
        controller: controller,
        key: key,
        onFieldSubmitted: (value) {
          if (labelText == 'Enter your adress') {
            return searchLocation(_adressController.text);
          } else {
            return null;
          }
        },
        keyboardType: keyboardType,
        decoration: InputDecoration(
            prefixIcon: Icon(icon),
            labelText: labelText,
            suffixIcon: lockIcon,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
            )),
      ),
    );
  }

  checkPermissionsAndGetLocation() async {
    setState(() {
      _isMapLoading = true;
    });

    bool _enabled = await Geolocator.isLocationServiceEnabled();
    if (_enabled == false) {
      setState(() {
        _isMapLoading = true;
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: Text('Turn on your location'),
            actions: [
              FlatButton(
                  onPressed: () async {
                    bool _position = await Geolocator.openLocationSettings();
                                      
                  },
                  child: Text('open your location'))
            ],
          ),
        );
      });
      return false;
    } else {
      Position _currentPosition = await Geolocator.getCurrentPosition();
      Marker _marker = Marker(
          markerId: MarkerId('1'),
          position:
              LatLng(_currentPosition.latitude, _currentPosition.longitude));
      setState(() {
        position = _currentPosition;
        markers.add(_marker);
        _isMapLoading = false;
      });
    }
  }

  searchLocation(String searchWord) async {
    setState(() {
      _isMapLoading = true;
    });

    List<Location> _search = await locationFromAddress(searchWord);
    Marker _newMarker = Marker(
        position: LatLng(_search[0].latitude, _search[0].longitude),
        markerId: MarkerId('1'));
    setState(() {
      location = _search[0];
      markers.add(_newMarker);
      _isMapLoading = false;
    });
  }

  locationContainer() {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        zoom: 16,
        target: _adressController.text.isEmpty
            ? LatLng(position.latitude, position.longitude)
            : LatLng(location.latitude, location.longitude),
      ),
      markers: Set.from(markers),
      mapType: MapType.normal,
      myLocationButtonEnabled: true,
      myLocationEnabled: true,
    );
  }
}
