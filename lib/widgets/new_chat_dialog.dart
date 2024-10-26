import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';
import '../models/user.dart';
import '../models/chat.dart';

class NewChatDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final databaseService = Provider.of<DatabaseService>(context);

    return AlertDialog(
      title: Text('Start a new chat'),
      content: FutureBuilder<List<User>>(
        future: databaseService.getAllUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Text('No users found. Please check your database.');
          }
          List<User> users = snapshot.data!
              .where((user) => user.id != authService.currentUser!.id)
              .toList();
          if (users.isEmpty) {
            return Text('No other users found.');
          }
          return SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: users.length,
              itemBuilder: (context, index) {
                User user = users[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: user.photoUrl != null
                        ? NetworkImage(user.photoUrl!)
                        : null,
                    child: user.photoUrl == null ? Text(user.name[0]) : null,
                  ),
                  title: Text(user.name),
                  onTap: () => _startNewChat(context, authService.currentUser!.id, user.id),
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _startNewChat(BuildContext context, String currentUserId, String selectedUserId) async {
    final databaseService = Provider.of<DatabaseService>(context, listen: false);
    String chatId = await databaseService.createChat([currentUserId, selectedUserId]);
    Navigator.of(context).pop(); // Close the dialog
    Navigator.pushNamed(
      context,
      '/chat',
      arguments: Chat(
        id: chatId,
        participantIds: [currentUserId, selectedUserId],
        lastMessageTime: DateTime.now(),
      ),
    );
  }
}