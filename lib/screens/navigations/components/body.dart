import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:prerok/components/default_button.dart';
import 'package:prerok/screens/complete_profile/complete_profile_screen.dart';
import 'package:prerok/screens/fund_page/complete_profile_screen.dart';
import 'package:prerok/screens/home/home_screen.dart';
import 'package:prerok/size_config.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  int pageIndex = 1;
  GlobalKey _bottomNavigationKey = GlobalKey();

  Color active = Colors.orange;
  Color notActive = Colors.grey;

  Color searchColor = Colors.orange;
  Color equalizerColor = Colors.grey;
  Color cardGiftCardColor = Colors.grey;
  Color personColor = Colors.grey;

  activeIcon(int index) {
    setState(() {
      pageIndex = index;
      switch (index) {
        case 0:
          searchColor = active;
          equalizerColor = notActive;
          cardGiftCardColor = notActive;
          personColor = notActive;
          break;
        case 1:
          searchColor = notActive;
          equalizerColor = active;
          cardGiftCardColor = notActive;
          personColor = notActive;
          break;
        case 2:
          searchColor = notActive;
          equalizerColor = notActive;
          cardGiftCardColor = active;
          personColor = notActive;
          break;
        case 3:
          searchColor = notActive;
          equalizerColor = notActive;
          cardGiftCardColor = notActive;
          personColor = active;
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _bottomNavigationKey,
      bottomNavigationBar: CurvedNavigationBar(
          index:1,
        backgroundColor: Color(0xffFF7642),
        height: 50,
        color: Colors.white,
        buttonBackgroundColor: Colors.white,
        items: <Widget>[
          Icon(Icons.account_balance),
          Icon(Icons.home),
          Icon(Icons.person),
        ],
        onTap: (index) {
          //Handle button tap
          setState(() {
            pageIndex = index;
            print(pageIndex.toString() + "sa");
          });
          activeIcon(index);
        },
      ),
      body: SafeArea(
        top: false,
        child: IndexedStack(
          index: pageIndex,
          children: <Widget>[
            // Navigator.pushNamed(context, HomeScreen.routeName);
            FundPageScreen(),
            HomeScreen(),
            CompleteProfileScreen(),
          ],
        ),
      ),
    );
  }
}
