import 'package:flutter/material.dart';
import 'package:mozz_test_task/screens/auth_screen/screens/login_screen.dart';
import 'package:mozz_test_task/screens/auth_screen/screens/sign_up_screen.dart';


class Authentificate extends StatefulWidget {
  const Authentificate({super.key});

  @override
  State<Authentificate> createState() => _AuthentificateState();
}

class _AuthentificateState extends State<Authentificate> {
  bool showLoginScreen = true;
  void toggleView(){
    setState(() {
    showLoginScreen = !showLoginScreen;
    });
  }
  @override
  Widget build(BuildContext context) {
    return showLoginScreen?LoginScreen(toggleView: toggleView):SignUpScreen(toggleView: toggleView,);
  }
}
