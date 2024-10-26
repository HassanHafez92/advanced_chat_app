import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/login_screen.dart';
import 'screens/registration_screen.dart';
import 'screens/chat_list_screen.dart';
import 'screens/chat_screen.dart';
import 'services/auth_service.dart';
import 'services/database_service.dart';
import 'services/message_service.dart';
import 'utils/theme.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthService>(
          create: (_) => AuthService(),
        ),
        Provider<DatabaseService>(
          create: (_) => DatabaseService(),
        ),
        Provider<MessageService>(
          create: (_) => MessageService(),
        ),
      ],
      child: MaterialApp(
        title: 'Chat App',
        theme: AppTheme.lightTheme,
        home: Consumer<AuthService>(
          builder: (context, authService, _) {
            if (authService.currentUser == null) {
              return LoginScreen();
            } else {
              return ChatListScreen();
            }
          },
        ),
        routes: {
          '/login': (context) => LoginScreen(),
          '/register': (context) => RegistrationScreen(),
          '/chat_list': (context) => ChatListScreen(),
          '/chat': (context) => ChatScreen(),
        },
      ),
    );
  }
}