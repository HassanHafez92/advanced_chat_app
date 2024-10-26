import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  final String id;
  final List<String> participantIds;
  final DateTime lastMessageTime;

  Chat({
    required this.id,
    required this.participantIds,
    required this.lastMessageTime,
  });

  factory Chat.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Chat(
      id: doc.id,
      participantIds: List<String>.from(data['participantIds'] ?? []),
      lastMessageTime: (data['lastMessageTime'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'participantIds': participantIds,
      'lastMessageTime': Timestamp.fromDate(lastMessageTime),
    };
  }
}