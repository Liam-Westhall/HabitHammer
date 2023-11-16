import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addUser(String userId, Map<String, dynamic> userData) async {
    await _firestore.collection('users').doc(userId).set(userData);
  }

  Future<void> addHabit(String userId, Map<String, dynamic> habitData) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('habits')
        .add(habitData);
  }

  Stream<QuerySnapshot> getHabits(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('habits')
        .snapshots();
  }
}
