import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';
import '../services/message_service.dart';
import '../models/chat.dart';
import '../models/message.dart';
import '../widgets/message_bubble.dart';
import '../widgets/chat_input.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Chat chat = ModalRoute.of(context)!.settings.arguments as Chat;
    final authService = Provider.of<AuthService>(context);
    final databaseService = Provider.of<DatabaseService>(context);
    final messageService = Provider.of<MessageService>(context);

    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder(
          future: databaseService.getUser(chat.participantIds
              .firstWhere((id) => id != authService.currentUser!.id)),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text('Loading...');
            }
            if (snapshot.hasData) {
              return Text(snapshot.data!.name);
            }
            return Text('Chat');
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Message>>(
              stream: messageService.getMessages(chat.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No messages yet'));
                }
                return ListView.builder(
                  reverse: true,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    Message message = snapshot.data![index];
                    bool isMe = message.senderId == authService.currentUser!.id;
                    return MessageBubble(
                      message: message,
                      isMe: isMe,
                    );
                  },
                );
              },
            ),
          ),
          ChatInput(
            onSendMessage: (content) async {
              await messageService.sendMessage(
                chatId: chat.id,
                content: content,
                senderId: authService.currentUser!.id,
              );
            },
          ),
        ],
      ),
    );
  }
}