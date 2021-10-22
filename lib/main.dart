import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:prerok/routes.dart';
import 'package:prerok/screens/navigations/navigation.dart';
import 'package:prerok/screens/sign_in/sign_in_screen.dart';
import 'package:prerok/screens/splash/splash_screen.dart';
import 'package:prerok/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  FirebaseAuth auth;

  // Create the initialization Future outside of `build`:
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Container(
            child: new Text("Something went wrong"),
          );
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          auth = FirebaseAuth.instance;
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'PREROK',
            theme: theme(),
            // home: SplashScreen(),
            // We use routeName so that we dont need to remember the name
            //initialRoute: SignInScreen.routeName,
            initialRoute: (auth.currentUser != null) ?  NavigationScreen.routeName : SplashScreen.routeName,
            routes: routes,
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Container(
          child: new Directionality(
              textDirection: TextDirection.ltr,
              child: new Text('waiting...'),
          ),
        );
      },
    );
  }
}
