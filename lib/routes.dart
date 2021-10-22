import 'package:flutter/widgets.dart';
import 'package:prerok/screens/cart/cart_screen.dart';
import 'package:prerok/screens/complete_profile/complete_profile_screen.dart';
import 'package:prerok/screens/deliverOrder/deliver_order_screen.dart';
import 'package:prerok/screens/details/details_screen.dart';
import 'package:prerok/screens/forgot_password/forgot_password_screen.dart';
import 'package:prerok/screens/home/home_screen.dart';
import 'package:prerok/screens/login_success/login_success_screen.dart';
import 'package:prerok/screens/navigations/navigation.dart';
import 'package:prerok/screens/otp/otp_screen.dart';
import 'package:prerok/screens/register_profile/register_profile_screen.dart';
import 'package:prerok/screens/sign_in/sign_in_screen.dart';
import 'package:prerok/screens/splash/splash_screen.dart';

import 'screens/sign_up/sign_up_screen.dart';

// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => SplashScreen(),
  SignInScreen.routeName: (context) => SignInScreen(),
  ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
  LoginSuccessScreen.routeName: (context) => LoginSuccessScreen(),
  SignUpScreen.routeName: (context) => SignUpScreen(),
  CompleteProfileScreen.routeName: (context) => CompleteProfileScreen(),
  RegisterProfileScreen.routeName: (context) => RegisterProfileScreen(),
  NavigationScreen.routeName: (context) => NavigationScreen(),
  OtpScreen.routeName: (context) => OtpScreen(),
  HomeScreen.routeName: (context) => HomeScreen(),
  DeliverOrderScreen.routeName: (context) => DeliverOrderScreen(),
  DetailsScreen.routeName: (context) => DetailsScreen(),
  CartScreen.routeName: (context) => CartScreen(),
};
