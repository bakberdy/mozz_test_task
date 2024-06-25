
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PasswordInputWidget extends StatefulWidget {
  const PasswordInputWidget({
    super.key,
    required TextEditingController passwordController,
    required this.themeData,
    required this.textTheme, required this.hintText,
  }) : _passwordController = passwordController;

  final TextEditingController _passwordController;
  final ThemeData themeData;
  final TextTheme textTheme;
  final String hintText;

  @override
  State<PasswordInputWidget> createState() => _PasswordInputWidgetState();
}

class _PasswordInputWidgetState extends State<PasswordInputWidget> {
  var _isHiddenPassword = true;

  void _showPassword() {
    _isHiddenPassword = !_isHiddenPassword;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget._passwordController,
      obscureText: _isHiddenPassword,
      cursorColor: Colors.black,
      decoration: InputDecoration(
        suffixIcon: GestureDetector(
            onTap: _showPassword,
            child: Icon(
              _isHiddenPassword
                  ? Icons.remove_red_eye
                  : CupertinoIcons.eye_slash_fill,
              color: widget.themeData.cardColor,
            )),
        fillColor: const Color(0xffF3F3F3),
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: widget.themeData.canvasColor),
          borderRadius: BorderRadius.circular(12),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: widget.themeData.canvasColor),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: widget.themeData.canvasColor),
          borderRadius: BorderRadius.circular(12),
        ),
        prefixIcon: Icon(
          Icons.lock,
          color: widget.themeData.cardColor,
        ),
        hintText: widget.hintText,
        hintStyle:
            widget.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
      ),
      keyboardType: TextInputType.visiblePassword,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Пожалуйста введите пароль';
        }
        return null;
      },
    );
  }
}
