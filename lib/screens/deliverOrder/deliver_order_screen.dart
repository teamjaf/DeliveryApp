import 'package:flutter/material.dart';

import 'components/body.dart';

class DeliverOrderScreen extends StatelessWidget {
  static String routeName = "/deliver_order";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Deliver'),
      ),
      body: Body(),
    );
  }
}
