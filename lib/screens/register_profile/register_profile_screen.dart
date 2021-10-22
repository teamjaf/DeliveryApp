import 'package:flutter/material.dart';

import 'components/body.dart';

class RegisterProfileScreen extends StatelessWidget {
  static String routeName = "/register_profile";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Body(),
    );
  }
}
