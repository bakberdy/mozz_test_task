import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:mozz_test_task/services/chat_service.dart';
import 'package:provider/provider.dart';

import '../../../models/custom_user.dart';
import '../../home_screen/widgets/user_tile.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key, required this.user});

  final CustomUser user;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ScrollController _scrollController = ScrollController();
  String message = "";
  final _messageController = TextEditingController();
  final _chatService = ChatService();
  final User? currentUser = FirebaseAuth.instance.currentUser;

  Future<List<DocumentSnapshot>> _getInitialMessagesAndConversations() async {
    var messageSnapshot =
        await _chatService.getMessages(currentUser?.uid ?? "").first;
    var conversationSnapshot =
        await _chatService.getConversations(currentUser?.uid ?? "").first;

    List<DocumentSnapshot> messages = [
      ...messageSnapshot.docs,
      ...conversationSnapshot.docs
    ];

    messages.sort((a, b) {
      Timestamp aTimestamp = a['timestamp'];
      Timestamp bTimestamp = b['timestamp'];
      return bTimestamp.compareTo(aTimestamp);
    });

    return messages;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    child: const Icon(CupertinoIcons.back, size: 30.0),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(width: 5.0),
                  Expanded(
                      child: Column(
                    children: [
                      const SizedBox(
                        height: 6,
                      ),
                      Center(
                        child: UserTile(
                          isItInAppBar: true,
                          lastMessage: "",
                          userName:
                              "${widget.user.name} ${widget.user.lastName}",
                          userAvatar: "",
                          onTap: () {},
                        ),
                      )
                    ],
                  )),
                ],
              ),
            ),
          ),
        ),
        body: SafeArea(
            child: Stack(
          children: [
            FutureBuilder<List<DocumentSnapshot>>(
              future: _getInitialMessagesAndConversations(),
              builder: (context, snapshot) {
                final CustomUser? user = Provider.of<CustomUser?>(context);
                List<DocumentSnapshot> messages = (snapshot.data ?? [])
                    .where((val) =>
                        (val['senderEmail'] == user?.email &&
                            val['recipientEmail'] == widget.user.email) ||
                        (val['recipientEmail'] == user?.email &&
                            val['senderEmail'] == widget.user.email))
                    .toList();

                return ListView.builder(
                  reverse: true,
                  controller: _scrollController,
                  itemCount: messages.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return const SizedBox(
                        height: 100,
                      );
                    } else {

                      var doc = messages[index - 1];
                      bool isMyMessage = doc['senderEmail']==user?.email;
                      String formattedTimestamp =
                          DateFormat('HH:mm').format(doc['timestamp'].toDate());
                      return Row(
                        mainAxisAlignment: isMyMessage?MainAxisAlignment.end:MainAxisAlignment.start,
                        children: [
                          Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: isMyMessage?Colors.greenAccent:Colors.grey.shade200,),
                              child: Row(children: [
                                Text("${doc['text']}", style: const TextStyle(fontSize: 16),),
                                const SizedBox(width: 10,),
                                Text(formattedTimestamp, style: const TextStyle(fontSize: 12),)
                              ]))
                        ],
                      );
                    }
                  },
                );
              },
            ),
            Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                    padding: EdgeInsets.zero,
                    color: Colors.white,
                    height: 100,
                    alignment: Alignment.topCenter,
                    child: Column(children: [
                      const Divider(),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 47,
                            width: 47,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.grey.shade200,
                            ),
                            child: Image.asset(
                              "assets/icons/attach.png",
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: TextFormField(
                              onFieldSubmitted: (val) {
                                  message = val;
                                  val="";
                                  _getInitialMessagesAndConversations();
                                _chatService.sendMessage(
                                    widget.user.email, message);
                              },
                              controller: _messageController,
                              cursorColor: Colors.black,
                              decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  fillColor: Colors.grey.shade200,
                                  filled: true,
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  hintText: "Сообщение",
                                  hintStyle:
                                      const TextStyle(color: Colors.grey)),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Container(
                              height: 48,
                              width: 48,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.grey.shade200,
                              ),
                              child: const Icon(
                                CupertinoIcons.mic,
                                color: Colors.black,
                              )),
                        ],
                      ),
                    ])))
          ],
        )));
  }
}
