import 'package:flutter/material.dart';
import 'package:mozz_test_task/screens/home_screen/widgets/user_tile.dart';

import '../widgets/search_bar_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        appBar: PreferredSize(
        preferredSize: const Size.fromHeight(160.0),
        child:Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
    child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50,),
              const Text(
                "Чаты",
                style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 5,),
              SearchBarWidget(
                textController: _searchController,
              ),
            ],
        ),)
      ),
        body: ListView.builder(
            itemCount: 5,
            itemBuilder: (context, index) => UserTile(
                lastMessage: "Что случилось?",
                userName: "Влад Тарасов",
                userAvatar: "userAvatar", onTap: () {  },)));
  }
}
