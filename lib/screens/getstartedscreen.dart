import 'package:anime/screens/signinscreen.dart';
import 'package:anime/screens/signupscreen.dart';
import 'package:flutter/material.dart';

class GetStarted extends StatefulWidget {
  @override
  _GetStartedState createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted> with TickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('Get Started'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(height * .06),
          child: TabBar(
            tabs: [Text('Sign in'), Text('Sign up')],
            controller: _tabController,
            labelStyle: TextStyle(fontSize: 16),
            unselectedLabelStyle: TextStyle(fontSize: 14.5),
            labelPadding: const EdgeInsets.all(8),
            indicatorPadding: const EdgeInsets.all(8),
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white, width: 2),
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          SignIn(),
          SignUp(),
        ],
      ),
    );
  }
}
