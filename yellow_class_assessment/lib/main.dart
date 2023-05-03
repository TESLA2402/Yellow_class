import 'package:firebase_auth/firebase_auth.dart';
import 'package:yellow_class_assessment/helper/authenticate.dart';
import 'package:yellow_class_assessment/screens/home.dart';
import 'package:yellow_class_assessment/screens/signin.dart';
//import 'package:chatapp/screens/welcome.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:yellow_class_assessment/services/database.dart';

import 'helper/shared_preference.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool? userIsLoggedIn = false;

  @override
  void initState() {
    getLoggedInState();
    super.initState();
  }

  getLoggedInState() async {
    await HelperFunctions.getUserLoggedInSharedPreference().then((value) {
      setState(() {
        userIsLoggedIn = value;
        print(userIsLoggedIn);
      });
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: //Authenticate()
            userIsLoggedIn == true ? HomeScreen() : Authenticate());
  }
}
