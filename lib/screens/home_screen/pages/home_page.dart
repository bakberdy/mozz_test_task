import 'package:flutter/material.dart';
import 'package:mozz_test_task/screens/home_screen/widgets/user_tile.dart';
import 'package:mozz_test_task/services/auth_service.dart';
import 'package:mozz_test_task/services/chat_service.dart';
import 'package:mozz_test_task/services/user_service.dart';
import 'package:provider/provider.dart';

import '../../../models/custom_user.dart';
import '../../chat_screen/pages/chat_page.dart';
import '../widgets/search_bar_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _searchController = TextEditingController();
  AuthService _auth = AuthService();
  UserService _userService = UserService();
  ChatService _chatService = ChatService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(160.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Чаты",
                          style: TextStyle(
                              fontSize: 32.0, fontWeight: FontWeight.w500),
                        ),
                        InkWell(
                          onTap: () {
                            _auth.signOut();
                          },
                          child: const Text(
                            "Log Out",
                            style: TextStyle(
                                color: Colors.red, fontWeight: FontWeight.w600),
                          ),
                        )
                      ]),
                  const SizedBox(
                    height: 5,
                  ),
                  SearchBarWidget(
                    textController: _searchController,
                  ),
                ],
              ),
            )),
        body: FutureBuilder<List<CustomUser>>(
            future: _userService.getUsers(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              final CustomUser? user = Provider.of<CustomUser?>(context);
              List<CustomUser> users = (snapshot.data ?? [])
                  .where((val) => (((val.email) != (user?.email ?? '')) &&
                      val.email != 'error'))
                  .toList();

              if (users.isEmpty) {
                return Center(child: Text('No users found'));
              }

              return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    return FutureBuilder<String?>(
                      future: _chatService.getLastMessageTextBetweenUsers(
                          users[index].email ?? '', user?.email ?? ''),
                      builder: (context, messageSnapshot) {
                        if (messageSnapshot.connectionState == ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (messageSnapshot.hasError) {
                          return Text('Error: ${messageSnapshot.error}');
                        } else {
                          final message = messageSnapshot.data ?? "";
                          return UserTile(
                            lastMessage: message.isEmpty ? "Начать чат" : message,
                            userName: "${users[index].name} ${users[index].lastName}",
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatPage(
                                    user: users[index],
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      },
                    );
                  });
            }));
  }
}
