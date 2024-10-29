import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:portfolio_app/components/drawer.dart';
import 'package:portfolio_app/components/search_bar.dart';
import 'package:portfolio_app/components/user_tile.dart';
import 'package:portfolio_app/pages/chat.dart';
import 'package:portfolio_app/services/auth/auth_service.dart';
import 'package:portfolio_app/services/chat/chat_service.dart';
import 'package:portfolio_app/services/chat/profile_pic.dart';
import 'package:portfolio_app/services/preload_data.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //Get Services
  final AuthService _authService = AuthService();
  final ChatService _chatService = ChatService();
  final ProfileService _profileService = ProfileService();

  //Search controller
  final TextEditingController searchController = TextEditingController();

  //Declarations
  String? profilePictureUrl;
  String? currentUserEmail;
  Timer? debounce;

  @override
  void initState() {
    super.initState();
    _loadProfileInfo();
    debounce?.cancel();
    searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    //Add debounce timer to prevent rebuilding
    if (debounce?.isActive ?? false) debounce!.cancel();
    debounce = Timer(const Duration(milliseconds: 500), () {
      // This triggers the build method only when necessary
      setState(() {});
    });
  }

  Future<void> _loadProfileInfo() async {
    String? url = await _profileService.getProfilePictureUrl();
    User? currentUser = _authService.getCurrentUser();
    setState(() {
      profilePictureUrl = url;
      currentUserEmail = currentUser?.email;
    });
  }

  bool _isImage(String message) {
    return message.startsWith('http');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          title: Text(
            'Chats',
            style: TextStyle(
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ),
          backgroundColor: Theme.of(context).colorScheme.surface,
          centerTitle: true,
          iconTheme:
              IconThemeData(color: Theme.of(context).colorScheme.tertiary),
        ),
        drawer: MyDrawer(
          profilePictureUrl: profilePictureUrl,
          currentUserEmail: currentUserEmail,
        ),
        body: Column(
          children: [
            MySearchBar(
              searchController: searchController,
            ),
            Expanded(child: _buildUserList())
          ],
        ),
      ),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _chatService.getUserStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print("StreamBuilder Error: ${snapshot.error}");
          return const Center(child: Text("An error occurred!"));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          print("StreamBuilder Loading...");
          return const Center(child: Text("Loading..."));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          print("StreamBuilder No Data");
          return const Center(child: Text("No users found"));
        }

        //Debuging prints
        print("StreamBuilder Data received: ${snapshot.data}");

        //Filter the user list based on serach query
        var users = snapshot.data!;
        var filteredUsers = searchController.text.isEmpty
            ? users
            : users
                .where((user) => user['email']
                    .toString()
                    .toLowerCase()
                    .contains(searchController.text.toLowerCase()))
                .toList();

        return ListView.builder(
          itemCount: filteredUsers.length,
          itemBuilder: (context, index) {
            return _buildUserListItem(filteredUsers[index], context);
          },
        );
      },
    );
  }

  Widget _buildUserListItem(
      Map<String, dynamic> userData, BuildContext context) {
    if (userData['email'] != _authService.getCurrentUser()?.email) {
      //Debugging prints
      print("Building user list item for ${userData['email']}");

      return StreamBuilder<QuerySnapshot>(
          stream: _chatService.getLastMessage(
              _authService.getCurrentUser()!.uid, userData['uid']),
          builder: (context, snapshot) {
            // Logging to debug multiple builds
            print(
                "LastMessage StreamBuilder for ${userData['email']} - ConnectionState: ${snapshot.connectionState}");

            //if the message is loading
            if (snapshot.connectionState == ConnectionState.waiting) {
              return UserTile(
                onTap: () => _navigateToChatPage(context, userData),
                text: userData['email'],
                profilePictureUrl: userData['photoUrl'],
                isLastMessageFromCurrentUser: false,
                lastMessage: '',
                lastMessageTimestamp: null,
              );
            }

            //If the message has error
            if (snapshot.hasError) {
              return UserTile(
                onTap: () => _navigateToChatPage(context, userData),
                text: userData['email'],
                profilePictureUrl: userData['photoUrl'],
                isLastMessageFromCurrentUser: false,
                lastMessage: "Error",
                lastMessageTimestamp: null,
              );
            }

            //Display the last message in the sser tile
            if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
              final lastMessageData = snapshot.data!.docs.first;
              final currentUserID = _authService.getCurrentUser()!.uid;
              final isLastMessageFromCurrentUser =
                  lastMessageData['senderID'] == currentUserID;

              String lastMessage = lastMessageData['message'];
              if (!isLastMessageFromCurrentUser && _isImage(lastMessage)) {
                lastMessage = "Sent you a photo 📷";
              }
              //Displays the timestamp of the last message
              final lastMessageTimestamp =
                  lastMessageData['timestamp'] as Timestamp;

              return UserTile(
                text: userData["email"],
                profilePictureUrl: userData["photoUrl"],
                lastMessage: lastMessage,
                isLastMessageFromCurrentUser: isLastMessageFromCurrentUser,
                onTap: () => _navigateToChatPage(context, userData),
                lastMessageTimestamp: lastMessageTimestamp,
              );
            }

            return UserTile(
              onTap: () => _navigateToChatPage(context, userData),
              text: userData['email'],
              profilePictureUrl: userData['photoUrl'],
              isLastMessageFromCurrentUser: false,
              lastMessage: 'No messages yet',
              lastMessageTimestamp: null,
            );
          });
    } else {
      return Container();
    }
  }

  //Method for switching to chat room
  void _navigateToChatPage(
      BuildContext context, Map<String, dynamic> userData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatPage(
          recieverEmail: userData["email"],
          recieverID: userData["uid"],
        ),
      ),
    );
  }
}
