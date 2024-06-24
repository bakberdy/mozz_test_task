import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  const UserTile({
    super.key,
    required this.lastMessage,
    required this.userName,
    required this.userAvatar,
    required this.onTap,
  });

  final String lastMessage;
  final String userName;
  final String userAvatar;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(padding: EdgeInsets.symmetric(horizontal: 15), child: Divider(
          thickness: 1.0,
          height: 1.0,
          color: Colors.grey.shade200
        ),),

        Container(
          margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 0.0),
          padding: const EdgeInsets.all(5.0),
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(userAvatar),
              backgroundColor: Colors.blue,
              radius: 35.0,
            ),
            title: Text(
              userName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            subtitle: Text(
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
