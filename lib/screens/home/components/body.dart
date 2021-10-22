import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:prerok/screens/deliverOrder/components/deliver_order_form.dart';
import 'package:prerok/screens/deliverOrder/deliver_order_screen.dart';

import '../../../size_config.dart';
import 'categories.dart';
import 'discount_banner.dart';
import 'home_header.dart';
import 'popular_product.dart';
import 'special_offers.dart';
import 'dart:math' as math;
import 'package:prerok/components/default_button.dart';
import 'package:prerok/components/default_image.dart';
import 'package:prerok/screens/sign_in/sign_in_screen.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> with TickerProviderStateMixin {
  String userId;
  String platformResponse;
  int g = 0;
  Timestamp date;
  FirebaseAuth auth;
  static const List<IconData> icons = const [
    Icons.sms,
    Icons.mail,
    Icons.phone
  ];
  AnimationController _controller;

  Future _signOut() async {
    await FirebaseAuth.instance.signOut();
    return Navigator.pushNamedAndRemoveUntil(
        context, SignInScreen.routeName, ModalRoute.withName('/'));
  }

  sendEmail(String subject, String body) async {
    final Email email = Email(
      body: body,
      subject: subject,
      recipients: ['prerokdeliveryapp@gmail.com'],
      isHTML: false,
    );

    try {
      await FlutterEmailSender.send(email);
      platformResponse = 'success';
      Scaffold.of(context).showSnackBar(
          SnackBar(content: Text("Email is sent" + platformResponse)));
    } catch (error) {
      platformResponse = error.toString();
      Scaffold.of(context).showSnackBar(SnackBar(
          content: Text("Email is not sent error: " + platformResponse)));
    }
  }

  @override
  void initState() {
    super.initState();

    auth = FirebaseAuth.instance;
    userId = auth.currentUser.uid;
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Theme.of(context).cardColor;
    Color foregroundColor = Theme.of(context).accentColor;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, DeliverOrderScreen.routeName);
          print("dsfg");
        },
        child: Icon(
          FontAwesomeIcons.plus,
          color: Colors.white,
          size: 29,
        ),
        backgroundColor: Color(0xffFF7642),
        tooltip: 'Capture Picture',
        elevation: 5,
        splashColor: Colors.grey,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 160,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Container(
                            width: SizeConfig.safeBlockHorizontal * 30,
                            child: DefaultImage(),
                          ),
                        ),
                        SizedBox(width: 5),
                        Flexible(
                          child: Container(
                            child: DefaultButton(
                              text: "Log Out",
                              press: () {
                                print("log out");
                                _signOut();
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Container(
                            child: DefaultButton(
                              text: "Urgent entry",
                              press: () {
                                print("urgent entry");
                                sendEmail(
                                    "Urgent entry",
                                    auth.currentUser.displayName.toString() +
                                        " user is looking for Urgent entry");
                              },
                            ),
                          ),
                        ),
                        SizedBox(width: 5),
                        Flexible(
                          child: Container(
                            child: DefaultButton(
                              text: "Urgent funds",
                              press: () {
                                print("urgent funds");
                                sendEmail(
                                    "Urgent funds",
                                    auth.currentUser.displayName.toString() +
                                        " user is looking for Urgent funds");
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 15),
                ],
              ),
            ),
            SizedBox(height: 15),
            if (g == 0)
              Center(
                child: Text(
                  "Order list is empty",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            Container(
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("userOrder")
                        .where("userId", isEqualTo: userId)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData || snapshot.hasError) {
                        return Center(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              "Order list is empty",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ));
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Container(
                          color: Theme.of(context).accentColor,
                          child: Container(),
                        );
                      } else {
                        g = 0;

                        return Expanded(
                          child: Container(
                            child: ListView(
                              children: makeListWidget(snapshot),
                            ),
                          ),
                        );
                      }
                    })),
            /*
                  SizedBox(height: getProportionateScreenHeight(20)),
                  HomeHeader(),
                  SizedBox(height: getProportionateScreenWidth(10)),
                  DiscountBanner(),
                  Categories(),
                  SpecialOffers(),
                  SizedBox(height: getProportionateScreenWidth(30)),
                  PopularProducts(),
                  SizedBox(height: getProportionateScreenWidth(30)),*/
          ],
        ),
      ),
    );
  }

  List<Widget> makeListWidget(AsyncSnapshot snapshot) {
    return snapshot.data.documents.map<Widget>((document) {
     /* print(snapshot.data.documents.length);*/
      date = document.get('selectedDate');

      return Container(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
        height: 280,
        width: double.maxFinite,
        child: Card(
          color: Color(0xffF7F7F7),
          child: Padding(
            padding: EdgeInsets.all(7),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
                  child: Text(
                    'Order No# ${++g}',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
                Container(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
                    child: Text(
                      'Deliver To:  ${document.get('fullName')}',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
                  child: Text(
                    'Phone Number:  ${document.get('phoneNumber')}',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
                  child: Text(
                    'Amount Collect:  ${document.get('expectedAmount')}',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
                  child: Text(
                    'Base Amount field:  ${document.get('amountCollectWithoutDeliveryCharges')}',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
                  child: Text(
                    'Address:  ${document.get('address')}',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
                  child: Text(
                    'Pickup date:  ${date.toDate().year} - ${date.toDate().month} - ${date.toDate().day}',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
                  child: Text(
                    'Status: ${document.get('orderStatus')}',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      /*    return ListTile(
        title: Text(document.get('name')),
        subtitle: Text(document.get('score').toString()),
      );*/
    }).toList();
  }
}
