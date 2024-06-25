import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mozz_test_task/screens/auth_screen/screens/reset_password_screen.dart';

import '../../../services/auth_service.dart';
import '../login_widgets/image_button_widget.dart';
import '../login_widgets/login_input_widget.dart';
import '../login_widgets/password_input_widget.dart';
import '../login_widgets/submit_button_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.toggleView});
  final VoidCallback toggleView;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = AuthService();
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var isLoading = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _loginController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final textTheme = themeData.textTheme;

    return Scaffold(
        appBar: AppBar(),
        body: isLoading?Center(child: LoadingAnimationWidget.inkDrop(color: Colors.blue, size: 40,)):
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30,),
                  Text(
                    "С возвращением",
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
                    height: 30,
                  ),
                  PasswordInputWidget(
                    passwordController: _passwordController,
                    themeData: themeData,
                    textTheme: textTheme,
                    hintText: 'Пароль',
                  ),
                  Container(
                      height: 30,
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ResetPasswordScreen()));
                        },
                        child: Text(
                          "Забыл пароль?",
                          style: textTheme.labelSmall?.copyWith(
                              color: themeData.primaryColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 12),
                        ),
                      )),
                  const SizedBox(
                    height: 50,
                  ),
                  SubmitButtonWidget(
                      themeData: themeData,
                      textTheme: textTheme,
                      title: 'Войти',
                      onPressed: () async {
                        if(_formKey.currentState?.validate()??false){
                          try {
                            await _auth.signInWithEmailAndPassword(
                                _loginController.text,
                                _passwordController.text);
                            setState(() {isLoading=true;});
                          } catch (e) {
                            Fluttertoast.showToast(
                                msg: "Sign In Failed",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0);
                            setState(() {isLoading=false;});
                          }
                        }
                      }),
                  const SizedBox(
                    height: 10,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Align(
                      child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "Создать аккаунт ",
                          style: textTheme.labelMedium
                              ?.copyWith(color: themeData.cardColor),
                        ),
                        TextSpan(
                          text: "Регистрация",
                          style: textTheme.labelMedium?.copyWith(
                            color: themeData.primaryColor,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap =widget.toggleView,
                        ),
                      ],
                    ),
                  ))
                ],
              ),
            ),
          ),
        ));
  }
}
