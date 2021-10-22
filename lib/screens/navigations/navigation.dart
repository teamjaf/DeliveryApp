import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:prerok/screens/complete_profile/complete_profile_screen.dart';
import 'package:prerok/screens/fund_page/complete_profile_screen.dart';
import 'package:prerok/screens/home/home_screen.dart';
import 'package:prerok/screens/navigations/components/body.dart';

import '../../size_config.dart';

class NavigationScreen extends StatefulWidget {
  static String routeName = "/navigation";

  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Body(),
    );
  }
}
