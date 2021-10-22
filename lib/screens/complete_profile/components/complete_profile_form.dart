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

class CompleteProfileForm extends StatefulWidget {
  @override
  _CompleteProfileFormState createState() => _CompleteProfileFormState();
}

class _CompleteProfileFormState extends State<CompleteProfileForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> errors = [];
  var _image;
  String fullName;
  String primaryFacebookPage;
  String phoneNumber;
  String address;
  String storeAddress;
  String bKashNumber;
  String personalAgent;
  String bankName;
  String bankBranch;
  String bankAccountNo;
  String accountOwnerName;

  int startOperation = 0;
  TextEditingController fullNameController;
  TextEditingController phoneNumberController;
  TextEditingController primaryFacebookPageController;
  TextEditingController addressController;
  TextEditingController storeAddressController;
  TextEditingController bKashNumberController;
  TextEditingController personalAgentController;
  TextEditingController bankNameController;
  TextEditingController bankBranchController;
  TextEditingController bankAccountNoController;
  TextEditingController accountOwnerNameController;

  @override
  void initState() {
    super.initState();
    getProfileData();
    fetchImage();
  }

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

    CollectionReference ref = FirebaseFirestore.instance
/*        .collection("user")
        .doc(userId)*/
        .collection("userProfile");

    ref
        .doc(userId)
        .get()
        .then((snapshot) {
          setState(() {
            if (snapshot != null) {
              print(snapshot.data()['fullName']);
              fullName = (snapshot.data()['fullName'] != null)
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
              bankName = (snapshot.data()['bankName'] != null)
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

              fullNameController = new TextEditingController(text: fullName);
              phoneNumberController =
                  new TextEditingController(text: phoneNumber);
              primaryFacebookPageController =
                  new TextEditingController(text: primaryFacebookPage);
              addressController = new TextEditingController(text: address);
              storeAddressController =
                  new TextEditingController(text: storeAddress);
              bKashNumberController =
                  new TextEditingController(text: bKashNumber);
              personalAgentController =
                  new TextEditingController(text: personalAgent);
              bankNameController = new TextEditingController(text: bankName);
              bankBranchController =
                  new TextEditingController(text: bankBranch);
              bankAccountNoController =
                  new TextEditingController(text: bankAccountNo);
              accountOwnerNameController =
                  new TextEditingController(text: accountOwnerName);
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
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8),
        child: Column(
          children: [
            showImage(),
            SizedBox(height: getProportionateScreenHeight(30)),
            buildFullNameFormField(),
            SizedBox(height: getProportionateScreenHeight(30)),
            buildFacebookPageField(),
            SizedBox(height: getProportionateScreenHeight(30)),
            buildPhoneNumberFormField(),
            SizedBox(height: getProportionateScreenHeight(30)),
            buildHomeAddressField(),
            SizedBox(height: getProportionateScreenHeight(30)),
            buildStoreAddressField(),
            SizedBox(height: getProportionateScreenHeight(30)),
            buildBkashNumberField(),
            SizedBox(height: getProportionateScreenHeight(30)),
            buildPersonalAgentField(),
            SizedBox(height: getProportionateScreenHeight(30)),
            buildBankNameField(),
            SizedBox(height: getProportionateScreenHeight(30)),
            buildBankBranchField(),
            SizedBox(height: getProportionateScreenHeight(30)),
            buildBankAccountNumberField(),
            SizedBox(height: getProportionateScreenHeight(30)),
            buildAccountOwnerNameField(),
            FormError(errors: errors),
            SizedBox(height: getProportionateScreenHeight(30)),
            DefaultButton(
              text: "Save Profile",
              press: () {
                completeProfileForm();
              },
            ),
            SizedBox(height: getProportionateScreenHeight(30)),
          ],
        ),
      ),
    );
  }

  completeProfileForm() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      FirebaseAuth auth;
      auth = FirebaseAuth.instance;
      CollectionReference ref = FirebaseFirestore.instance
          /*.collection("user")
          .doc(auth.currentUser.uid)*/
          .collection("userProfile");
      ref
          .doc(auth.currentUser.uid)
          .set(
            {
              'fullName': fullName,
              'primaryFacebookPage': primaryFacebookPage,
              'phoneNumber': phoneNumber,
              'address': address,
              'storeAddress': storeAddress,
              'bKashNumber': bKashNumber,
              'personalAgent': personalAgent,
              'bankName': bankName,
              'bankBranch': bankBranch,
              'bankAccountNo': bankAccountNo,
              'accountOwnerName': accountOwnerName,
            },
          )
          .then((value) => {
                Scaffold.of(context).showSnackBar(
                    SnackBar(content: Text('Profile data is updated')))
              })
          .catchError(
            (error) => print(
              error.toString(),
            ),
          );
    }
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
    fetchImage();
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

  TextFormField buildFullNameFormField() {
    return TextFormField(
      controller: fullNameController,
      onSaved: (newValue) => fullName = newValue,
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
        labelText: "Full Name",
        hintText: "Enter your full name",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }

  TextFormField buildPhoneNumberFormField() {
    return TextFormField(
      controller: phoneNumberController,
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

  TextFormField buildFacebookPageField() {
    return TextFormField(
      controller: primaryFacebookPageController,
      onSaved: (newValue) => primaryFacebookPage = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kNamelNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kFacebookNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Primary Facebook Page",
        hintText: "Enter your primary facebook page",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(
          FontAwesomeIcons.facebook,
          size: 29,
        ),
      ),
    );
  }

  TextFormField buildHomeAddressField() {
    return TextFormField(
      controller: addressController,
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

  TextFormField buildStoreAddressField() {
    return TextFormField(
      controller: storeAddressController,
      onSaved: (newValue) => storeAddress = newValue,
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
        labelText: "Store Address",
        hintText: "Enter your store address",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon:
            CustomSurffixIcon(svgIcon: "assets/icons/Location point.svg"),
      ),
    );
  }

  TextFormField buildBkashNumberField() {
    return TextFormField(
      controller: bKashNumberController,
      onSaved: (newValue) => bKashNumber = newValue,
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
        labelText: "Bkash Number",
        hintText: "Enter your bkash number",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(Icons.drive_file_rename_outline),
        //  CustomSurffixIcon(svgIcon: "assets/icons/Location point.svg"),
      ),
    );
  }

  TextFormField buildPersonalAgentField() {
    return TextFormField(
      controller: personalAgentController,
      onSaved: (newValue) => personalAgent = newValue,
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
        labelText: "Personal/Agent",
        hintText: "Personal/Agent",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(Icons.person),
        //CustomSurffixIcon(svgIcon: "assets/icons/Location point.svg"),
      ),
    );
  }

  TextFormField buildBankNameField() {
    return TextFormField(
      controller: bankNameController,
      onSaved: (newValue) => bankName = newValue,
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
        labelText: "Bank Name",
        hintText: "Enter bank name",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(Icons.drive_file_rename_outline),
        //CustomSurffixIcon(svgIcon: "assets/icons/Location point.svg"),
      ),
    );
  }

  TextFormField buildBankBranchField() {
    return TextFormField(
      controller: bankBranchController,
      onSaved: (newValue) => bankBranch = newValue,
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
        labelText: "Bank Branch",
        hintText: "Enter bank branch",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(Icons.drive_file_rename_outline),
        //CustomSurffixIcon(svgIcon: "assets/icons/Location point.svg"),
      ),
    );
  }

  TextFormField buildBankAccountNumberField() {
    return TextFormField(
      controller: bankAccountNoController,
      onSaved: (newValue) => bankAccountNo = newValue,
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
        labelText: "Bank Account number",
        hintText: "Enter bank account number",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(Icons.drive_file_rename_outline),
        //  CustomSurffixIcon(svgIcon: "assets/icons/Location point.svg"),
      ),
    );
  }

  TextFormField buildAccountOwnerNameField() {
    return TextFormField(
      controller: accountOwnerNameController,
      onSaved: (newValue) => accountOwnerName = newValue,
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
        labelText: "Account Owner Name",
        hintText: "Enter account owner name",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(Icons.person),
        // CustomSurffixIcon(svgIcon: "assets/icons/Location point.svg"),
      ),
    );
  }
}
