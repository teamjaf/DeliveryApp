import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../constants.dart';
import '../size_config.dart';

class FacebookButton extends StatelessWidget {
  const FacebookButton({
    Key key,
    this.text,
    this.press,
  }) : super(key: key);
  final String text;
  final Function press;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      // height: getProportionateScreenHeight(56),
      height: 50,

      child: FlatButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: kBlueColor,
        onPressed: press,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(
              FontAwesomeIcons.facebook,
              color: Colors.white,
              size: 29,
            ),
            //SizedBox(width: getProportionateScreenHeight(20)),
            Text(
              text,
              style: TextStyle(
                fontSize: getProportionateScreenWidth(18),
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
