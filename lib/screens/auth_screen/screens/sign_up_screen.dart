import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mozz_test_task/screens/auth_screen/login_widgets/name_input_widget.dart';

import '../../../services/auth_service.dart';
import '../login_widgets/last_name_input_widget.dart';
import '../login_widgets/login_input_widget.dart';
import '../login_widgets/password_input_widget.dart';
import '../login_widgets/submit_button_widget.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key, required this.toggleView});
  final VoidCallback toggleView;

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _auth = AuthService();

  final _formKey = GlobalKey<FormState>();
  final _loginController = TextEditingController();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _passwordConfirmController = TextEditingController();
  var isLoading = false;

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _passwordConfirmController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final textTheme = themeData.textTheme;
    return Scaffold(
      appBar: AppBar(),
      body: isLoading?Center(child: LoadingAnimationWidget.inkDrop(color: Colors.blue, size: 40),):
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Создать \nаккаунт!",
                style: textTheme.titleLarge,
              ),
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
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
                      NameInputWidget(
                          loginController: _firstNameController,
                          themeData: themeData,
                          textTheme: textTheme),
                      const SizedBox(
                        height: 30,
                      ),
                      LastNameInputWidget(
                          loginController: _lastNameController,
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
                      const SizedBox(
                        height: 30,
                      ),
                      PasswordInputWidget(
                        passwordController: _passwordConfirmController,
                        themeData: themeData,
                        textTheme: textTheme,
                        hintText: 'Подтверждение пароля',
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  )),
              const SizedBox(
                height: 20,
              ),
              SubmitButtonWidget(
                themeData: themeData,
                textTheme: textTheme,
                title: 'Создать аккаунт',
                onPressed: () async {
                  var password = _passwordController.text;
                  var email = _loginController.text;
                  var confirmPassword = _passwordConfirmController.text;
                  var firstName = _firstNameController.text;
                  var lastName = _lastNameController.text;
                  if (_formKey.currentState?.validate() ?? false) {
                    if (password == confirmPassword) {
                      try {
                        setState(() {
                          isLoading=true;
                        });
                        await _auth.signUpWithEmailAndPassword(
                            email, password , firstName,lastName);
                      } catch (e) {
                        setState(() {
                         isLoading = false;

                        });
                        Fluttertoast.showToast(
                            msg: e.toString(),
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);

                      }
                    } else {
                      Fluttertoast.showToast(
                          msg: "Don't correspond confirm password",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);
                      setState(() {
                      isLoading=false;

                      });
                    }
                  }
                },
              ),
              const SizedBox(
                height: 50,
              ),
              Align(
                  child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: "У меня уже есть аккаунт ",
                      style: textTheme.labelMedium
                          ?.copyWith(color: themeData.cardColor),
                    ),
                    TextSpan(
                      text: "Войти",
                      style: textTheme.labelMedium?.copyWith(
                        color: themeData.primaryColor,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap =widget.toggleView
                    ),
                  ],
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
