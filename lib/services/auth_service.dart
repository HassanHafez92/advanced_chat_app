import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import '../models/user.dart';
import 'database_service.dart';

class AuthService with ChangeNotifier {
  final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;
  final DatabaseService _databaseService = DatabaseService();

  User? _userFromFirebase(auth.User? user) {
    if (user == null) {
      return null;
    }
    return User(id: user.uid, name: user.displayName ?? '', email: user.email!);
  }

  Stream<User?> get user {
    return _firebaseAuth.authStateChanges().map(_userFromFirebase);
  }

  User? get currentUser {
    return _userFromFirebase(_firebaseAuth.currentUser);
  }

  Future<User?> signIn(String email, String password) async {
    final credential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    notifyListeners();
    return _userFromFirebase(credential.user);
  }

  Future<User?> register(String name, String email, String password) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await credential.user!.updateDisplayName(name);

      User newUser = User(
        id: credential.user!.uid,
        name: name,
        email: email,
      );

      await _databaseService.createUser(newUser);

      print("User registered and added to Firestore: ${newUser.id}");

      notifyListeners();
      return newUser;
    } catch (e) {
      print("Error during registration: $e");
      return null;
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    notifyListeners();
  }
}