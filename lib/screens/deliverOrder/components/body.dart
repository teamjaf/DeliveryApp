import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../size_config.dart';
import 'deliver_order_form.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: SizeConfig.screenHeight * 0.03),
                SizedBox(height: SizeConfig.screenHeight * 0.02),
                DeliverOrderForm(),
                SizedBox(height: getProportionateScreenHeight(30)),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
