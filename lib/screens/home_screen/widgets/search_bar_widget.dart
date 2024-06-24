
import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({
    super.key,
    required TextEditingController textController,
  }) : _textController = textController;

  final TextEditingController _textController;

  @override
  Widget build(BuildContext context) {
    return Container(
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(15),
  ),
  child: TextFormField(
    controller: _textController,
    cursorColor: Colors.black,
    decoration: InputDecoration(
      contentPadding: EdgeInsets.zero,
      fillColor: Colors.grey.shade200,
      filled: true,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(12),
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(12),
      ),
      prefixIcon: Icon(
        Icons.search,
        color:Colors.grey
      ),
      hintText: "Поиск",
      hintStyle: TextStyle(color:Colors.grey )
    ),
    // Set keyboard type to email address
  ),
);

  }
}
