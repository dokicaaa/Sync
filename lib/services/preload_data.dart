import 'package:flutter/material.dart';
import 'package:portfolio_app/services/chat/profile_pic.dart';

class PreloadService {
  final ProfileService _profileService = ProfileService();

  //Fetch the user data and preload profile pictures
  Future<void> preloadUserData(
      BuildContext context, List<Map<String, dynamic>> users) async {
    for (var user in users) {
      if (user['photoUrl'] != null) {
        await precacheImage(NetworkImage(user['photoUrl']), context);
      }
    }
  }
}
