import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mozz_test_task/models/custom_user.dart';

class UserService {
  final CollectionReference _userCollection = FirebaseFirestore.instance.collection('users');

  Future<List<CustomUser>> getUsers() async {
    QuerySnapshot snapshot = await _userCollection.get();
    return snapshot.docs.map((doc) => CustomUser(lastName: doc['lastName'], uid: '', name: doc['firstName'], email: doc['email'],)).toList();
  }
}
