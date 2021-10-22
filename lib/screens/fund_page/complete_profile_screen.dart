import 'package:flutter/material.dart';

import 'components/body.dart';

class FundPageScreen extends StatelessWidget {
  static String routeName = "/complete_profile";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
/*      appBar: AppBar(
        title: Text('Profile'),
      ),*/
      body: Body(),
    );
  }
}
