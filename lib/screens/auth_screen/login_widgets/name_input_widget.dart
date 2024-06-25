
import 'package:flutter/material.dart';

class NameInputWidget extends StatelessWidget {
  const NameInputWidget({
    super.key,
    required TextEditingController loginController,
    required this.themeData,
    required this.textTheme,
  }) : _loginController = loginController;

  final TextEditingController _loginController;
  final ThemeData themeData;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _loginController,
      cursorColor: Colors.black,
      decoration: InputDecoration(
        fillColor: const Color(0xffF3F3F3),
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: themeData.canvasColor),
          borderRadius: BorderRadius.circular(12),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: themeData.canvasColor),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: themeData.canvasColor),
          borderRadius: BorderRadius.circular(12),
        ),
        prefixIcon: Icon(
          Icons.person,
          color: themeData.cardColor,
        ),
        hintText: "Имя",
        hintStyle: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
      ),
      keyboardType: TextInputType.emailAddress,
      // Set keyboard type to email address
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Введите имю';
        }
        return null;
      },
    );
  }
}
