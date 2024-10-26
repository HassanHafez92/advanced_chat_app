import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> createUser(User user) async {
    try {
      print("Attempting to create user document in Firestore: ${user.id}");
      await _db.collection('users').doc(user.id).set(user.toMap());
      print("User document successfully created in Firestore");
    } catch (e) {
      print("Error creating user document: $e");
      throw e;
    }
  }

  Future<User?> getUser(String userId) async {
    DocumentSnapshot doc = await _db.collection('users').doc(userId).get();
    return doc.exists ? User.fromFirestore(doc) : null;
  }

  Future<String?> getChatId(String userId1, String userId2) async {
    QuerySnapshot snapshot = await _db
        .collection('chats')
        .where('participantIds', arrayContains: userId1)
        .get();

    for (var doc in snapshot.docs) {
      List<String> participantIds = List<String>.from(doc['participantIds']);
      if (participantIds.contains(userId2)) {
        return doc.id;
      }
    }

    return null;
  }

  Future<String> createChat(List<String> participantIds) async {
    DocumentReference chatRef = await _db.collection('chats').add({
      'participantIds': participantIds,
      'lastMessageTime': FieldValue.serverTimestamp(),
    });
    return chatRef.id;
  }

  Future<void> updateLastMessageTime(String chatId) async {
    await _db.collection('chats').doc(chatId).update({
      'lastMessageTime': FieldValue.serverTimestamp(),
    });
  }
  Future<List<User>> getAllUsers() async {
    try {
      print("Attempting to fetch users from Firestore...");
      QuerySnapshot snapshot = await _db.collection('users').get();
      print("Fetched ${snapshot.docs.length} user documents from Firestore");

      if (snapshot.docs.isEmpty) {
        print("No user documents found in Firestore");
        return [];
      }

      List<User> users = snapshot.docs.map((doc) {
        try {
          User user = User.fromFirestore(doc);
          print("Successfully parsed user: ${user.id} - ${user.name}");
          return user;
        } catch (e) {
          print("Error parsing user document ${doc.id}: $e");
          return null;
        }
      }).whereType<User>().toList();

      print("Parsed ${users.length} valid users");
      return users;
    } catch (e) {
      print("Error fetching users: $e");
      return [];
    }
  }

}