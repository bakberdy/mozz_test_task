import 'dart:math';
import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  const UserTile({
    super.key,
    required this.lastMessage,
    required this.userName,
    required this.onTap,
    this.isItInAppBar = false,
  });

  final String lastMessage;
  final String userName;
  final VoidCallback onTap;
  final bool isItInAppBar;

  String getInitials(String name) {
    if (name.isEmpty) {
      return "";
    }
    List<String> nameParts = name.split(' ');
    nameParts.removeWhere((part) => part.isEmpty);
    if (nameParts.isEmpty) {
      return "";
    }
    if (nameParts.length > 1) {
      return nameParts[0][0] + nameParts[1][0];
    } else {
      return nameParts[0][0];
    }
  }

  Color getRandomColor() {
    final List<Color> colors = [
      Colors.red,
      Colors.green,
      Colors.blue,
      Colors.orange,
      Colors.purple,
      Colors.teal,
    ];
    return colors[Random().nextInt(colors.length)];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        isItInAppBar
            ? const SizedBox.shrink()
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Divider(
                    thickness: 1.0, height: 1.0, color: Colors.grey.shade200),
              ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 0.0),
          padding: const EdgeInsets.all(5.0),
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: getRandomColor(),
              radius: 24.0,
              child: Text(
                getInitials(userName),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
            ),
            title: Text(
              userName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            subtitle: isItInAppBar
                ? Text(
                    "В сети",
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14.0,
                    ),
                  )
                : Text(
                    lastMessage,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14.0,
                    ),
                  ),
            onTap: onTap,
          ),
        ),
      ],
    );
  }
}
