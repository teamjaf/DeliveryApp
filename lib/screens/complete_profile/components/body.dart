import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
  Future _signOut() async {
    await FirebaseAuth.instance.signOut();
    return Navigator.pushNamedAndRemoveUntil(
        context, SignInScreen.routeName, ModalRoute.withName('/'));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            Container(
              height: 150,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(width: 5),
                        Flexible(
                          child: Container(
                            width: SizeConfig.screenWidth * 0.3,
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
                  Text("Update Profile", style: headingStyle),
                  Text(
                    "Update your details",
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.02),
                ],
              ),
            ),

            Expanded(
              child: ListView(
                children: [
                  CompleteProfileForm(),
                ],
              ),
            )
            //
          ],
        ),
      ),
    );
  }
}
