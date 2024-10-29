import 'package:flutter/material.dart';
import 'package:portfolio_app/components/profile_avatar.dart';
import 'package:portfolio_app/pages/profile.dart';
import 'package:portfolio_app/services/auth/auth_service.dart';
import 'package:portfolio_app/pages/settings.dart';

class MyDrawer extends StatelessWidget {
  final String? profilePictureUrl;
  final String? currentUserEmail;

  const MyDrawer(
      {super.key,
      required this.profilePictureUrl,
      required this.currentUserEmail});

  void logout() {
    //Get auth service
    final _auth = AuthService();
    _auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //Logo
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 20, top: 80, bottom: 40, right: 20),
                child: Row(
                  children: [
                    ProfileAvatar(
                      imageUrl: profilePictureUrl,
                      radius: 32,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Hello,",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),

                          //Display the currents users email
                          Text(
                            currentUserEmail ?? "",
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w100),
                            overflow: TextOverflow.ellipsis,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),

              const Divider(
                thickness: 1,
                indent: 16,
                endIndent: 16,
                color: Colors.grey,
              ),

              //Profile list tile
              Padding(
                padding: EdgeInsets.only(left: 10, top: 30),
                child: ListTile(
                  title: Text(
                    "Profile",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.tertiary,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    //Pop the drawer
                    Navigator.pop(context);

                    //Navigate to settings
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfilePage(),
                        ));
                  },
                  leading: Icon(
                    Icons.person_rounded,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ),
              ),

              //Settings list title
              Padding(
                padding: EdgeInsets.only(left: 10, top: 30),
                child: ListTile(
                  title: Text(
                    "Settings",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.tertiary,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    //Pop the drawer
                    Navigator.pop(context);

                    //Navigate to settings
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SettingsPage(),
                        ));
                  },
                  leading: Icon(
                    Icons.settings_rounded,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ),
              ),
            ],
          ),

          //Logout list title
          Padding(
            padding: EdgeInsets.only(left: 10, top: 30, bottom: 20),
            child: ListTile(
              title: Text(
                "Logout",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.tertiary,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
              onTap: logout,
              leading: Icon(
                Icons.logout_rounded,
                color: Theme.of(context).colorScheme.tertiary,
              ),
            ),
          )
        ],
      ),
    );
  }
}
