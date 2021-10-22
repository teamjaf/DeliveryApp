import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../size_config.dart';

class DefaultImage extends StatefulWidget {
  static String urlImage;

  const DefaultImage({
    Key key,

  }) : super(key: key);


  @override
  _DefaultImageState createState() => _DefaultImageState();
}

class _DefaultImageState extends State<DefaultImage> {

  String userId;

  fetchImage() async {
    userId = (FirebaseAuth.instance.currentUser).uid;

    final ref = FirebaseStorage.instance.ref().child(userId);
// no need of the file extension, the name will do fine.
    //print(ref.name + " ddfsdfg");
    DefaultImage.urlImage = await ref.getDownloadURL();
    // print(urlImage);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fetchImage();

  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
     // height: getProportionateScreenHeight(56),
      child: CircleAvatar(
        radius: 30,
        // backgroundColor: Color(0xff476cfb),
        child: ClipOval(
          child: new SizedBox(
            width: 60.0,
            height: 60.0,
            child: (DefaultImage.urlImage != null)
                ? Image.network(
              DefaultImage.urlImage,
              fit: BoxFit.fill,
            )
                : Image.asset(
              "assets/images/profile.png",
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  }
}
