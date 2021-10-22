import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:prerok/components/default_button.dart';
import 'package:prerok/components/default_image.dart';
import 'package:prerok/screens/sign_in/sign_in_screen.dart';

import '../../../constants.dart';
import '../../../size_config.dart';
import 'complete_profile_form.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String platformResponse = '';
  FirebaseAuth auth;

  Future _signOut() async {
    await FirebaseAuth.instance.signOut();
    return Navigator.pushNamedAndRemoveUntil(
        context, SignInScreen.routeName, ModalRoute.withName('/'));
  }

  popUpDialog() {
    return AlertDialog(
      title: Text('Note:'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text('This page is under development'),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Approve'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
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
      platformResponse = 'successfully';
      Scaffold.of(context).showSnackBar(
          SnackBar(content: Text("Email is sent " + platformResponse)));
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
  }

  @override
  Widget build(BuildContext context) {
    //popUpDialog();
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Column(
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
            Expanded(
              child: ListView(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Center(
                        child: Text(
                          "This page is under development",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                      SizedBox(width: 5),
                      Container(
                        padding: EdgeInsets.all(8),
                        width: SizeConfig.screenWidth,
                        child: Card(
                          color: Color(0xffF7F7F7),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              SizedBox(height: 15),
                              Center(
                                child: Container(
                                  child: Text(
                                    'Total Collection',
                                    style:
                                        Theme.of(context).textTheme.headline5,
                                  ),
                                ),
                              ),
                              SizedBox(height: 15),
                              Center(
                                child: Container(
                                  child: Text(
                                    '0 BDT',
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                ),
                              ),
                              SizedBox(height: 15),
                            ],
                          ),
                        ),
                      ),
                      //  SizedBox(height: 15),
                      Container(
                        padding: EdgeInsets.all(8),
                        width: SizeConfig.screenWidth,
                        child: Card(
                          color: Color(0xffF7F7F7),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              SizedBox(height: 15),
                              Center(
                                child: Container(
                                  child: Text(
                                    'Collection left',
                                    style:
                                        Theme.of(context).textTheme.headline5,
                                  ),
                                ),
                              ),
                              SizedBox(height: 15),
                              Center(
                                child: Container(
                                  child: Text(
                                    '0 BDT',
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                ),
                              ),
                              SizedBox(height: 15),
                            ],
                          ),
                        ),
                      ),
                      //   SizedBox(height: 15),
                      Container(
                        padding: EdgeInsets.all(8),
                        width: SizeConfig.screenWidth,
                        child: Card(
                          color: Color(0xffF7F7F7),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              SizedBox(height: 15),
                              Center(
                                child: Container(
                                  child: Text(
                                    'Sent your account',
                                    style:
                                        Theme.of(context).textTheme.headline5,
                                  ),
                                ),
                              ),
                              SizedBox(height: 15),
                              Center(
                                child: Container(
                                  child: Text(
                                    '0 BDT',
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                ),
                              ),
                              SizedBox(height: 15),
                            ],
                          ),
                        ),
                      ),
                      // SizedBox(height: 15),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
