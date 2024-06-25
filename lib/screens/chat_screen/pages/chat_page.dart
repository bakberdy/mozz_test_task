import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mozz_test_task/services/chat_service.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

import '../../../models/custom_user.dart';
import '../../home_screen/widgets/user_tile.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key, required this.user}) : super(key: key);

  final CustomUser user;

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ScrollController _scrollController = ScrollController();
  String message = "";
  final _messageController = TextEditingController();
  final _chatService = ChatService();
  final User? currentUser = FirebaseAuth.instance.currentUser;

  Stream<List<DocumentSnapshot>>? _combinedStream;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  void _loadInitialData() async {
    _combinedStream = Rx.combineLatest2(
      _chatService
          .getMessages(currentUser?.uid ?? "")
          .map((snapshot) => snapshot.docs),
      _chatService
          .getConversations(currentUser?.uid ?? "")
          .map((snapshot) => snapshot.docs),
      (List<DocumentSnapshot> messages, List<DocumentSnapshot> conversations) {
        return [
          ...messages,
          ...conversations,
        ]..sort((a, b) {
            Timestamp aTimestamp = a['timestamp'];
            Timestamp bTimestamp = b['timestamp'];
            return bTimestamp.compareTo(aTimestamp);
          });
      },
    );

    try {
      await _chatService.getMessages(currentUser?.uid ?? "").first;
      await _chatService.getConversations(currentUser?.uid ?? "").first;
      _chatService.sendMessage("error", "message");
    } catch (e) {
      // Handle error
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    //_combinedStream?.drain();
    super.dispose();
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
                      const SizedBox(height: 6),
                      Center(
                        child: UserTile(
                          isItInAppBar: true,
                          lastMessage: "",
                          userName:
                              "${widget.user.name} ${widget.user.lastName}",
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            StreamBuilder<List<DocumentSnapshot>>(
              stream: _combinedStream,
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
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    var doc = messages[index];
                    bool isMyMessage = doc['senderEmail'] == user?.email;
                    String formattedTimestamp =
                        DateFormat('HH:mm').format(doc['timestamp'].toDate());
                    bool showDateSeparator = false;

                    String dateLabel = getDateLabel(doc['timestamp'].toDate());

                    if (index < messages.length - 1) {
                      var nextDoc = messages[index + 1];
                      var currentMessageDate = doc['timestamp'].toDate();
                      var nextMessageDate = nextDoc['timestamp'].toDate();

                      if (!isSameDay(currentMessageDate, nextMessageDate)) {
                        showDateSeparator = true;
                      }
                    } else {
                      showDateSeparator = true;
                    }

                    return Column(
                      children: [
                        if (showDateSeparator)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              dateLabel,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        Row(
                          mainAxisAlignment: isMyMessage
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: isMyMessage
                                    ? Colors.greenAccent
                                    : Colors.grey.shade200,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(context).size.width *
                                              0.6,
                                    ),
                                    child: Text(
                                      "${doc['text']}",
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    formattedTimestamp,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        if (index == 0)
                          const SizedBox(
                            height: 100,
                          ),
                      ],
                    );
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
                child: Column(
                  children: [
                    const Divider(),
                    const SizedBox(height: 5),
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
                        const SizedBox(width: 5),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: TextFormField(
                            onFieldSubmitted: (val) {
                              setState(() {
                                message = val;
                              });
                              _sendMessage();
                            },
                            controller: _messageController,
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 10),
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
                              hintStyle: const TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        InkWell(
                          onTap: () {
                            setState(() {
                              message = _messageController.text;
                              _messageController.clear();
                              _sendMessage();
                            });
                          },
                          child: Container(
                            height: 47,
                            width: 47,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.black,
                            ),
                            child: const Icon(
                              Icons.arrow_upward,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _sendMessage() {
    if (message.isNotEmpty) {
      _chatService.sendMessage(widget.user.email, message);
      _messageController.clear();
      message = "";
       //_loadInitialData();
    }
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  String getDateLabel(DateTime date) {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime yesterday = DateTime(now.year, now.month, now.day - 1);

    if (isSameDay(date, today)) {
      return "Сегодня";
    } else if (isSameDay(date, yesterday)) {
      return "Вчера";
    } else {
      return DateFormat('yyyy-MM-dd').format(date);
    }
  }
}
