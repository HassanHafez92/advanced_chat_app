import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/message.dart';
import 'database_service.dart';

class MessageService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final DatabaseService _databaseService = DatabaseService();

  Stream<List<Message>> getMessages(String chatId) {
    return _db
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Message.fromFirestore(doc)).toList());
  }

  Future<void> sendMessage({
    required String chatId,
    required String content,
    required String senderId,
  }) async {
    await _db.collection('chats').doc(chatId).collection('messages').add({
      'senderId': senderId,
      'content': content,
      'timestamp': FieldValue.serverTimestamp(),
    });
    await _databaseService.updateLastMessageTime(chatId);
  }
}
