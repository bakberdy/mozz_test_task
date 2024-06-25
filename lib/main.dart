import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mozz_test_task/screens/auth_screen/authentificate.dart';
import 'package:mozz_test_task/screens/home_screen/pages/home_page.dart';
import 'package:mozz_test_task/services/auth_service.dart';
import 'package:provider/provider.dart';

import 'models/custom_user.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
          apiKey: 'AIzaSyBujbbiLqs3mMR7Hk1uzBYso-aHOg8zEBE',
          appId: '1:1022389640700:android:5f7dcddc62b44494a32679',
          messagingSenderId: '1022389640700',
          projectId: 'messanger-967ef',
          storageBucket: 'messanger-967ef.appspot.com',
        ))
      : await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return StreamProvider<CustomUser?>.value(
    value: AuthService().user,
    initialData: null,
    child:
      MaterialApp(debugShowCheckedModeBanner: false,
      theme: ThemeData(
        cardColor: const Color(0xff626262),
        primaryColor: Colors.blue,
        canvasColor: const Color(0xffA8A8A9),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xffFCF3F6)),
        useMaterial3: true,
      ),
      home: const Wrapper(),
    ));
  }
}


class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final CustomUser? user = Provider.of<CustomUser?>(context);
    return user==null?const Authentificate():const HomePage();  }
}
