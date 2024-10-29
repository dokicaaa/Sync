import 'package:flutter/material.dart';
import 'package:googleapis/displayvideo/v2.dart';
import 'package:portfolio_app/services/auth/auth_gate.dart';
import 'package:portfolio_app/services/preload_data.dart';
import 'package:portfolio_app/services/chat/chat_service.dart';
import 'package:portfolio_app/pages/home_page.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final PreloadService _preloadService = PreloadService();
  final ChatService _chatService = ChatService();

  @override
  void initState() {
    super.initState();
    _preloadDataAndNavigate();
  }

  Future<void> _preloadDataAndNavigate() async {
    try {
      List<Map<String, dynamic>> users = await _chatService.getUsers();
      await _preloadService.preloadUserData(context, users);
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (context) => const AuthGate()),
      // );
    } catch (e) {
      print("Error preloading data: $e");
      // Handle error (show error message or retry)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [],
        ),
      ),
    );
  }
}
