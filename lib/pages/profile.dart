import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/datamigration/v1.dart';
import 'package:googleapis/firebasedynamiclinks/v1.dart';
import 'package:googleapis/forms/v1.dart';
import 'package:portfolio_app/components/info_field.dart';
import 'package:portfolio_app/components/profile_avatar.dart';
import 'package:portfolio_app/services/auth/auth_service.dart';
import 'package:portfolio_app/services/chat/profile_pic.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  //Services
  final ProfileService _profileService = ProfileService();
  final AuthService _authService = AuthService();

  //Variables
  String? profilePictureUrl;
  String? currentUserEmail;

  @override
  void initState() {
    super.initState();
    _loadProfileInfo();
  }

  Future<void> _loadProfileInfo() async {
    String? url = await _profileService.getProfilePictureUrl();
    User? currentUser = _authService.getCurrentUser();
    setState(() {
      profilePictureUrl = url;
      currentUserEmail = currentUser?.email;
    });
  }

  void selectAndUploadImage() async {
    final file = await _profileService.pickImage();
    if (file != null) {
      String? imageUrl =
          await _profileService.uploadImageAndUpdateProfile(file);
      if (imageUrl != null) {
        setState(() {
          profilePictureUrl = imageUrl;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(
            color: Theme.of(context).colorScheme.tertiary,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        centerTitle: true,
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.tertiary),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Stack(
              children: [
                ProfileAvatar(
                  imageUrl: profilePictureUrl,
                  radius: 54,
                ),
                Positioned(
                  right: 2,
                  bottom: 2,
                  child: Container(
                    height: 32,
                    width: 32,
                    alignment: Alignment.center,
                    child: IconButton(
                        onPressed: selectAndUploadImage,
                        icon: Icon(
                          Icons.edit_rounded,
                          size: 18,
                          color: Theme.of(context).colorScheme.tertiary,
                        )),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(
                              0.4), // Shadow color with some transparency
                          spreadRadius:
                              1, // Extent of the shadow in all directions
                          blurRadius: 2, // How blurred the shadow should be
                          offset: Offset(-2, 0), // Changes position of shadow
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(height: 20),
            Divider(
              thickness: 1,
              indent: 20,
              endIndent: 20,
              color: Theme.of(context).colorScheme.primary,
            ),
            SizedBox(height: 20),
            InfoField(
                icon: Icons.mail_outline_rounded,
                text: currentUserEmail ?? "...")
          ],
        ),
      ),
    );
  }
}
