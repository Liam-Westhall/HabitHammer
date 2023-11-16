import 'package:firebase_auth/firebase_auth.dart';

class AppUser {
  final String id;
  final String email;

  AppUser({required this.id, required this.email});

  factory AppUser.fromFirebaseUser(User user) {
    return AppUser(id: user.uid, email: user.email!);
  }
}
