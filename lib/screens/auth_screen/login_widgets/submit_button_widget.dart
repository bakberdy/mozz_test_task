
import 'package:flutter/material.dart';

class SubmitButtonWidget extends StatelessWidget {
  const SubmitButtonWidget({
    super.key,
    required this.themeData,
    required this.textTheme, required this.title, required this.onPressed,
  });

  final ThemeData themeData;
  final TextTheme textTheme;
  final String title;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(themeData.primaryColor),
            shape: WidgetStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5)))),
        onPressed: onPressed,
        child: Text(
          title,
          style: textTheme.labelLarge,
        ),
      ),
    );
  }
}
