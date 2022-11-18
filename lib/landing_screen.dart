import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tgcd/provider/auth_provider.dart';
import 'package:tgcd/screen/avatar_screen.dart';
import 'package:tgcd/screen/dashboard_screen.dart';
import 'package:tgcd/screen/login_screen.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() => context.read<AuthProvider>().userAuthStatus(context));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, provider, child) {
        return FutureBuilder(
            future: provider.userLoggedIn,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data == 3) {
                  return DashBoardScreen();
                } else if (snapshot.data == 2) {
                  return AvatarScreen();
                } else {
                  return LoginScreen();
                }
              } else if (snapshot.hasError) {
                return Icon(Icons.error_outline);
              } else {
                return Center(child: CircularProgressIndicator());
              }
            });
      },
    );
  }
}
