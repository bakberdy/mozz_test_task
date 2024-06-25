
import 'package:flutter/material.dart';

class ImageButtonWidget extends StatelessWidget {
  const ImageButtonWidget({
    super.key,
    required this.themeData,
    required this.picture,
    required this.onPressed,
  });

  final String picture;
  final ThemeData themeData;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: 60,
      child: IconButton(
          style: ButtonStyle(
            side: WidgetStateProperty.all(
                BorderSide(color: themeData.primaryColor)),
            shadowColor: WidgetStateProperty.all(const Color(0xffFCF3F6)),
            backgroundColor: WidgetStateProperty.all(const Color(0xffFCF3F6)),
          ),
          onPressed: onPressed,
          icon: Image.network(picture)),
    );
  }
}


