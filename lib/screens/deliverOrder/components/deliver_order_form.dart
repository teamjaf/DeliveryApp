import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prerok/components/custom_surfix_icon.dart';
import 'package:prerok/components/default_button.dart';
import 'package:prerok/components/form_error.dart';
import 'package:prerok/screens/home/home_screen.dart';
import 'package:prerok/screens/otp/otp_screen.dart';
import 'package:prerok/screens/sign_in/sign_in_screen.dart';
import 'package:prerok/components/default_image.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class DeliverOrderForm extends StatefulWidget {
  @override
  _DeliverOrderFormState createState() => _DeliverOrderFormState();
}

class _DeliverOrderFormState extends State<DeliverOrderForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> errors = [];
  var _image;
  String deliverTo;
  String primaryFacebookPage;
  String phoneNumber;
  String expectedAmount;
  String amountCollectWithoutDeliveryCharges;
  String address;
  String storeAddress;
  String bKashNumber;
  String personalAgent;
  String pickUpDate;
  String bankBranch;
  String bankAccountNo;
  String accountOwnerName;
  String orderStatus = "Waiting to pick up";

  /// Which holds the selected date
  /// Defaults to today's date.
  DateTime selectedDate = DateTime.now();
  static const _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();

  @override
  void initState() {
    super.initState();
    //getProfileData();
  }

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  void addError({String error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  getProfileData() {
    String userId = (FirebaseAuth.instance.currentUser).uid;

    CollectionReference ref =
        FirebaseFirestore.instance.collection("userProfile");

    ref
        .doc(userId)
        .get()
        .then((snapshot) {
          setState(() {
            if (snapshot != null) {
              print(snapshot.data()['fullName']);
              deliverTo = (snapshot.data()['fullName'] != null)
                  ? snapshot.data()['fullName']
                  : '';
              primaryFacebookPage =
                  (snapshot.data()['primaryFacebookPage'] != null)
                      ? snapshot.data()['primaryFacebookPage']
                      : '';
              phoneNumber = (snapshot.data()['phoneNumber'] != null)
                  ? snapshot.data()['phoneNumber']
                  : '';
              address = (snapshot.data()['address'] != null)
                  ? snapshot.data()['address']
                  : '';
              storeAddress = (snapshot.data()['storeAddress'] != null)
                  ? snapshot.data()['storeAddress']
                  : '';
              bKashNumber = (snapshot.data()['bKashNumber'] != null)
                  ? snapshot.data()['bKashNumber']
                  : '';
              personalAgent = (snapshot.data()['personalAgent'] != null)
                  ? snapshot.data()['personalAgent']
                  : '';
              pickUpDate = (snapshot.data()['bankName'] != null)
                  ? snapshot.data()['bankName']
                  : '';
              bankBranch = (snapshot.data()['bankBranch'] != null)
                  ? snapshot.data()['bankBranch']
                  : '';
              bankAccountNo = (snapshot.data()['bankAccountNo'] != null)
                  ? snapshot.data()['bankAccountNo']
                  : '';
              accountOwnerName = (snapshot.data()['accountOwnerName'] != null)
                  ? snapshot.data()['accountOwnerName']
                  : '';
            }
          });
        })
        .then((value) => print("success"))
        .catchError((onError) {});
  }

  @override
  Widget build(BuildContext context) {
    //getProfileData();

    return Form(
      key: _formKey,
      child: Column(
        children: [
          SizedBox(height: getProportionateScreenHeight(30)),
          buildDeliverToFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPhoneNumberFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildAddressField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildExpectedAmountFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildAmountCollectWithoutDeliveryChargesFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPickUpDateField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          FormError(errors: errors),
          //SizedBox(height: getProportionateScreenHeight(40)),
          DefaultButton(
            text: "Deliver",
            press: () {
              completeDeliverForm();
            },
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  completeDeliverForm() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      FirebaseAuth auth;
      auth = FirebaseAuth.instance;
      CollectionReference ref =
          FirebaseFirestore.instance.collection("userOrder");
      ref
          .doc(getRandomString(10))
          .set(
            {
              'fullName': deliverTo,
              'phoneNumber': phoneNumber,
              'address': address,
              'expectedAmount': expectedAmount,
              'amountCollectWithoutDeliveryCharges':
                  amountCollectWithoutDeliveryCharges,
              'selectedDate': selectedDate,
              'orderStatus': orderStatus,
              'userId': auth.currentUser.uid,
            },
          )
          .then((value) => {afterOrderStatus()})
          .catchError(
            (error) => print(
              error.toString(),
            ),
          );
    }
  }

  afterOrderStatus() {
    Scaffold.of(context)
        .showSnackBar(SnackBar(content: Text('Order data is updated')));
    Future.delayed(Duration(seconds: 2), () {
      Navigator.of(context).pop();
    });
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
      print('Image Path $_image');
      uploadPic(context);
    });
  }

  Future uploadPic(BuildContext context) async {
    if (_image != null) {
      String userId = (FirebaseAuth.instance.currentUser).uid;

      String fileName = _image.path.split('/').last;
      Reference firebaseStorageRef =
          FirebaseStorage.instance.ref().child(userId);
      UploadTask uploadTask = firebaseStorageRef.putFile(_image);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(
        () => setState(() {
          print("Profile Picture uploaded");

/*        Navigator.pushNamedAndRemoveUntil(
            context, HomeScreen.routeName, ModalRoute.withName('/'));*/
        }),
      );
    }
    Scaffold.of(context)
        .showSnackBar(SnackBar(content: Text('Profile data is updated')));
    //  var downloadUrl = await taskSnapshot.ref.getDownloadURL();
  }

  fetchImage() async {
    String userId = (FirebaseAuth.instance.currentUser).uid;

    final ref = FirebaseStorage.instance.ref().child(userId);
// no need of the file extension, the name will do fine.
    //print(ref.name + " ddfsdfg");
    DefaultImage.urlImage = await ref.getDownloadURL();
    // print(urlImage);
    setState(() {});
  }

  Widget showImage() {
    fetchImage();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Align(
          alignment: Alignment.center,
          child: CircleAvatar(
            radius: 65,
            // backgroundColor: Color(0xff476cfb),
            child: ClipOval(
              child: new SizedBox(
                width: 120.0,
                height: 120.0,
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
        ),
        Padding(
          padding: EdgeInsets.only(top: 60.0),
          child: IconButton(
            icon: Icon(
              FontAwesomeIcons.camera,
              size: 30.0,
            ),
            onPressed: () {
              getImage();
            },
          ),
        ),
      ],
    );
  }

  TextFormField buildDeliverToFormField() {
    return TextFormField(
      onSaved: (newValue) => deliverTo = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kNamelNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kNamelNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Deliver To",
        hintText: "Enter Name",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }

  TextFormField buildPhoneNumberFormField() {
    return TextFormField(
      keyboardType: TextInputType.phone,
      onSaved: (newValue) => phoneNumber = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPhoneNumberNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kPhoneNumberNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Phone Number",
        hintText: "Enter your phone number",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Phone.svg"),
      ),
    );
  }

  TextFormField buildExpectedAmountFormField() {
    return TextFormField(
      keyboardType: TextInputType.phone,
      onSaved: (newValue) => expectedAmount = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kExpectedAmountNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kExpectedAmountNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Expected Amount",
        hintText: "Enter expected Amount",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(Icons.attach_money),
      ),
    );
  }

  TextFormField buildAmountCollectWithoutDeliveryChargesFormField() {
    return TextFormField(
      keyboardType: TextInputType.phone,
      onSaved: (newValue) => amountCollectWithoutDeliveryCharges = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kAmountCollectWithoutDeliveryChargesNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kAmountCollectWithoutDeliveryChargesNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Base Amount field",
        hintText: "Expected amount without parcel",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(Icons.attach_money),
      ),
    );
  }

  TextFormField buildAddressField() {
    return TextFormField(
      onSaved: (newValue) => address = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kAddressNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kAddressNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Address",
        hintText: "Enter your address",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon:
            CustomSurffixIcon(svgIcon: "assets/icons/Location point.svg"),
      ),
    );
  }

  buildPickUpDateField() {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text("${selectedDate.toLocal()}".split(' ')[0]),
          SizedBox(
            width: 20.0,
          ),
          RaisedButton(
            onPressed: () => _selectDate(context),
            child: Text('Select date'),
          ),
        ],
      ),
    );
  }
}
