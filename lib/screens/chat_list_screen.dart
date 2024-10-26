import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';
import '../models/user.dart';
import '../models/chat.dart';

class ChatListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final databaseService = Provider.of<DatabaseService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Users'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () async {
              await authService.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: FutureBuilder<List<User>>(
        future: databaseService.getAllUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No users found'));
          }

          List<User> users = snapshot.data!
              .where((user) => user.id != authService.currentUser!.id)
              .toList();

          return ListView.builder(
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
                subtitle: Text(user.email),
                onTap: () => _startOrOpenChat(context, authService.currentUser!.id, user.id),
              );
            },
          );
        },
      ),
    );
  }

  void _startOrOpenChat(BuildContext context, String currentUserId, String selectedUserId) async {
    final databaseService = Provider.of<DatabaseService>(context, listen: false);

    // Check if a chat already exists between these users
    String? existingChatId = await databaseService.getChatId(currentUserId, selectedUserId);

    if (existingChatId != null) {
      // If chat exists, open it
      Navigator.pushNamed(
        context,
        '/chat',
        arguments: Chat(
          id: existingChatId,
          participantIds: [currentUserId, selectedUserId],
          lastMessageTime: DateTime.now(), // You might want to fetch the actual last message time
        ),
      );
    } else {
      // If chat doesn't exist, create a new one
      String newChatId = await databaseService.createChat([currentUserId, selectedUserId]);
      Navigator.pushNamed(
        context,
        '/chat',
        arguments: Chat(
          id: newChatId,
          participantIds: [currentUserId, selectedUserId],
          lastMessageTime: DateTime.now(),
        ),
      );
    }
  }
}