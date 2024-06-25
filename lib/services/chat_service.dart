import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> sendMessage(String recipientEmail, String messageText) async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw 'User not authenticated';
      }

      String senderEmail = currentUser.email!;
      String senderUid = currentUser.uid;

      QuerySnapshot recipientQuery = await _firestore.collection('users').where('email', isEqualTo: recipientEmail).limit(1).get();
      if (recipientQuery.docs.isEmpty) {
        throw 'Recipient not found';
      }

      DocumentSnapshot recipientDoc = recipientQuery.docs.first;
      String recipientUid = recipientDoc.id;

      await _firestore.collection('messages').add({
        'senderUid': senderUid,
        'senderEmail': senderEmail,
        'recipientUid': recipientUid,
        'recipientEmail': recipientEmail,
        'text': messageText,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Failed to send message: $e');
      rethrow;
    }
  }

  Stream<QuerySnapshot> getMessages(String userUid) {
    return _firestore.collection('messages')
        .where('senderUid', isEqualTo: userUid)
        .orderBy('timestamp', descending: true)
        .snapshots();

  }

  Stream<QuerySnapshot> getConversations(String userUid) {
    return _firestore.collection('messages')
        .where('recipientUid', isEqualTo: userUid)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
  Future<String?> getLastMessageTextBetweenUsers(String user1Email, String user2Email) async {
  try {
    QuerySnapshot messageQuery = await _firestore.collection('messages')
        .where('senderEmail', whereIn: [user1Email, user2Email])
        .where('recipientEmail', whereIn: [user1Email, user2Email])
        .orderBy('timestamp', descending: true)
        .limit(1)
        .get();

    if (messageQuery.docs.isNotEmpty) {
      return messageQuery.docs.first['text'];
    } else {
      return null;
    }
  } catch (e) {
    print('Failed to get last message: $e');
    return null;
  }
}

}
