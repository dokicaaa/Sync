import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:googleapis/androidenterprise/v1.dart' as androidenterprise;
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:portfolio_app/components/message_bubble.dart';
import 'package:portfolio_app/components/chat_input.dart';
import 'package:portfolio_app/components/profile_avatar.dart';
import 'package:portfolio_app/services/auth/auth_service.dart';
import 'package:portfolio_app/services/chat/chat_service.dart';
import 'package:portfolio_app/services/chat/profile_pic.dart';
import 'package:portfolio_app/services/media_service.dart';

class ChatPage extends StatefulWidget {
  final String recieverEmail;
  final String recieverID;
  ChatPage({super.key, required this.recieverEmail, required this.recieverID});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  //Text controller
  final TextEditingController _messageController = TextEditingController();

  //Chat and auth services
  final ChatService chatService = ChatService();
  final AuthService authService = AuthService();
  final MediaService mediaService = MediaService();
  final ProfileService profileService = ProfileService();

  //Focus Node for textfield
  FocusNode focusNode = FocusNode();

  //Variables
  String? profilePictureUrl;
  final GlobalKey lastMessageKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _getOtherUserPorfilePicture();
    //Listener for the focus node
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        //Delay for loading, then scroll down
        Future.delayed(
          const Duration(
            milliseconds: 50,
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    focusNode.dispose();
    _messageController.dispose();
    super.dispose();
  }

  //Scroll controller
  final ScrollController scrollController = ScrollController();
  void scrollDown() {
    scrollController.jumpTo(scrollController.position.maxScrollExtent);
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (scrollController.hasClients) {
          scrollController.jumpTo(
            scrollController.position.maxScrollExtent,
          );
        }
      });
    });
  }

  bool _isUrl(String text) {
    Uri? uri = Uri.tryParse(text);
    return uri != null && (uri.scheme == 'http' || uri.scheme == 'https');
  }

  void sendMessage(String message) async {
    if (_messageController.text.isNotEmpty || _isUrl(message)) {
      //if the message is not empty
      if (message.isNotEmpty) {
        //Send message
        await chatService.sendMessage(widget.recieverID, message);

        //Clear the controller after sending
        _messageController.clear();
      }
      scrollDown();
    }
  }

  Future<void> checkGalleryPermissions(ImageSource source) async {
    if (source == ImageSource.gallery) {
      //Check the current premissions
      PermissionStatus status = await Permission.photos.status;

      if (status.isGranted) {
        // Permission is granted, pck the image
        await pickAndUploadMedia(source);
      } else if (status.isDenied) {
        //Ask for new premissions
        PermissionStatus newStatus = await Permission.photos.request();

        //Check again and go to gallery
        if (newStatus.isGranted) {
          await pickAndUploadMedia(source);
        } else {
          //Permission is permanently denied, open app settings
          openAppSettings();
        }
      } else if (status.isPermanentlyDenied) {
        // Permission is permanently denied, open app settings
        openAppSettings();
      }
    }
  }

  Future<void> pickAndUploadMedia(
    ImageSource source,
  ) async {
    File? file = await mediaService.pickImage(source);
    if (file != null) {
      String fileName = file.path.split('/').last;
      String? downloadUrl = await mediaService.uploadFile(file, fileName);
      if (downloadUrl != null) {
        sendMessage(downloadUrl); // Send the download URL as a message
      } else {
        print('Failed to upload media');
      }
    } else {
      print('No file picked');
    }
  }

  //Load other users profile picture
  void _getOtherUserPorfilePicture() async {
    String? reciverProfileUrl =
        await profileService.getUserProfilePictureUrl(widget.recieverID);
    profilePictureUrl = reciverProfileUrl;
    // Update the UI after fetching the profile picture
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ProfileAvatar(imageUrl: profilePictureUrl, radius: 20),
            SizedBox(width: 10),
            Expanded(
                child: Text(
              widget.recieverEmail,
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.tertiary,
                overflow: TextOverflow.ellipsis,
              ),
            ))
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        centerTitle: true,
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.tertiary),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        children: [
          //Display messages
          Expanded(child: _buildMessageList()),

          //User input
          _buildUserInput()
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    String senderID = authService.getCurrentUser()!.uid;
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: StreamBuilder(
        stream: chatService.getMessages(widget.recieverID, senderID),
        builder: (context, snapshot) {
          //Error
          if (snapshot.hasError) {
            return const Text("Error");
          }

          //loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading messages...");
          }

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (scrollController.hasClients) {
              _scrollToBottom();
            }
          });

          // List of messages
          List<Widget> messageList = snapshot.data!.docs
              .map<Widget>((doc) => _buildMessageItem(doc))
              .toList();

          // Add the header text at the beginning
          messageList.insert(
              0,
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: Center(
                  child: Text(
                    "No messages yet. Start the conversation!",
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                  ),
                ),
              ));

          return ListView(
            controller: scrollController,
            children: messageList,
          );
        },
      ),
    );
  }

  //Build message item
  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    //Is current user
    bool isCurrentUser = data['senderID'] == authService.getCurrentUser()!.uid;

    //Aligne messages to left side if sender is current user, otherwise left
    var aligment = isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
        alignment: aligment,
        child: Column(
          crossAxisAlignment:
              isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            ChatBubble(
                message: data["message"],
                isCurrentUser: isCurrentUser,
                timestamp: data['timestamp'],
                onImageLoaded: _scrollToBottom),
          ],
        ));
  }

  //Build message input
  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //Message field
          Expanded(
            child: Padding(
                padding: const EdgeInsets.only(left: 12, right: 12),
                child: ChatInput(
                  hintText: "Message...",
                  obscureText: false,
                  controller: _messageController,
                  focusNode: focusNode,
                  onMediaUpload: () =>
                      checkGalleryPermissions(ImageSource.gallery),
                  customColor: Theme.of(context).colorScheme.primary,
                )),
          ),

          //Send button
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              shape: BoxShape.circle,
            ),
            margin: EdgeInsets.only(right: 12),
            child: IconButton(
                onPressed: () => sendMessage(_messageController.text),
                icon: Icon(
                  Icons.send_rounded,
                  color: Colors.white,
                )),
          ),
        ],
      ),
    );
  }
}
