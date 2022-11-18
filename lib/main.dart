import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tgcd/landing_screen.dart';
import 'package:tgcd/provider/all_user_provider.dart';
import 'package:tgcd/provider/auth_provider.dart';
import 'package:tgcd/provider/notification.dart';
import 'package:tgcd/provider/post_provider.dart';
import 'package:tgcd/provider/user_provider.dart';
import 'package:tgcd/util/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => AllUserProvider()),
        ChangeNotifierProvider(create: (context) => PostProvider()),
        ChangeNotifierProvider(create: (context) => NotificationProvider()),
      ],
      child: MaterialApp(
        title: 'TGCD',
        theme: appLightTheme,
        home: LandingScreen(),
      ),
    );
  }
}
