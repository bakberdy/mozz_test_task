import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


import '../../../services/auth_service.dart';
import '../login_widgets/login_input_widget.dart';
import '../login_widgets/submit_button_widget.dart';

class ResetPasswordScreen extends StatelessWidget {
  ResetPasswordScreen({super.key});

  final _auth = AuthService();

  final _loginController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final textTheme = themeData.textTheme;
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Forgot \npassword?",
                style: textTheme.titleLarge,
              ),
              const SizedBox(
                height: 30,
              ),
              LoginInputWidget(
                  loginController: _loginController,
                  themeData: themeData,
                  textTheme: textTheme),
              const SizedBox(
                height: 10,
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                        text: " * ",
                        style: textTheme.bodySmall
                            ?.copyWith(color: Colors.red, fontSize: 20)),
                    TextSpan(
                        text:
                            "We will send you a message to set or reset your new password",
                        style: textTheme.bodySmall
                            ?.copyWith(color: themeData.cardColor)),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              SubmitButtonWidget(
                themeData: themeData,
                textTheme: textTheme,
                title: 'Submit',
                onPressed: () async {
                  try {
                    await _auth.changePassword(_loginController.text);
                    Fluttertoast.showToast(
                        msg: "We sent a link to your email.",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.green,
                        textColor: Colors.white,
                        fontSize: 16.0);
                    Navigator.pop(context);
                  } catch (e) {
                    Fluttertoast.showToast(
                        msg: "Incorrect data",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  }
                },
              ),
              const SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
