import 'package:flutter/material.dart';
import '../models/user.dart';

class UserAvatar extends StatelessWidget {
  final User user;
  final double radius;

  UserAvatar({required this.user, this.radius = 20});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundImage: user.photoUrl != null ? NetworkImage(user.photoUrl!) : null,
      child: user.photoUrl == null ? Text(user.name[0].toUpperCase()) : null,
    );
  }
}