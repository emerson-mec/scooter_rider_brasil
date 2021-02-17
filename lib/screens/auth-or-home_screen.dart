import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scooter_rider_brasil/providers/auth.dart';

import 'auth_screen.dart';
import 'feed/feed_screen.dart';

class AuthOrHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context);
    return auth.isAuth ? FeedScreen() : AuthScrenn();
  }
}