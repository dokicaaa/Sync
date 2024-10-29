// import 'dart:convert';
// import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:portfolio_app/components/message_bubble.dart';
// import 'package:portfolio_app/components/chat_input.dart';
// import 'package:portfolio_app/components/profile_avatar.dart';
// import 'package:portfolio_app/services/auth/auth_service.dart';
// import 'package:portfolio_app/services/chat/chat_service.dart';
// import 'package:portfolio_app/services/chat/profile_pic.dart';
// import 'package:portfolio_app/services/media_service.dart';

// class ChatPage extends StatefulWidget {
//   final String recieverEmail;
//   final String recieverID;
//   ChatPage({super.key, required this.recieverEmail, required this.recieverID});

//   @override
//   State<ChatPage> createState() => _ChatPageState();
// }

// class _ChatPageState extends State<ChatPage> {
//   //Text controller
//   final TextEditingController _messageController = TextEditingController();

//   //Chat and auth services
//   final ChatService chatService = ChatService();
//   final AuthService authService = AuthService();
//   final MediaService mediaService = MediaService();
//   final ProfileService profileService = ProfileService();


//   //Focus Node for textfield
//   FocusNode focusNode = FocusNode();

//     //Variables
//   String? profilePictureUrl;

//   @override
//   void initState() {
//     super.initState();

//      _getOtherUserPorfilePicture();


//     //Listener for the focus node
//     focusNode.addListener(() {
//       if (focusNode.hasFocus) {
//         //Delay so that the keyboard has time to show up
//         //then the amount of remaining space will be calculated
//         //After that sroll down
//         Future.delayed(
//           const Duration(
//             milliseconds: 50,
//           ),
//           () => scrollDown(),
//         );
//       }
//     });

//     //Wait a bit for the listview to build then scroll to the bottom
//     Future.delayed(const Duration(milliseconds: 100), () => scrollDown());
//   }

//   @override
//   void dispose() {
//     focusNode.dispose();
//     _messageController.dispose();
//     super.dispose();
//   }

//   //Scroll controller
//   final ScrollController scrollController = ScrollController();
//   void scrollDown() {
//     scrollController.jumpTo(scrollController.position.maxScrollExtent);
//   }

//   void sendMessage(String message) async {
//     //if the message is not empty
//     if (message.isNotEmpty) {
//       //Send message
//       await chatService.sendMessage(widget.recieverID, message);

//       //Clear the controller after sending
//       _messageController.clear();
//     }

//     scrollDown();
//   }

//   //Media handling and uploading
//   Future<void> handleMediaUpload(ImageSource source, bool isImage) async {
//     File? file;
//     if (isImage) {
//       file = await mediaService.pickImage(source);
//     } else {
//       file = await mediaService.pickVideo(source);
//     }

//     if (file != null) {
//       String fileName = file.path.split('/').last;
//       String? downloadUrl = await mediaService.uploadFile(file, fileName);
//       if (downloadUrl != null) {
//         sendMessage(downloadUrl); // Send the download URL as a message
//       } else {
//         print('Failed to upload media');
//       }
//     } else {
//       print('No file picked');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           widget.recieverEmail,
//           style: TextStyle(
//             color: Theme.of(context).colorScheme.tertiary,
//           ),
//         ),
//         backgroundColor: Theme.of(context).colorScheme.surface,
//         centerTitle: true,
//         iconTheme: IconThemeData(color: Theme.of(context).colorScheme.tertiary),
//       ),
//       backgroundColor: Theme.of(context).colorScheme.surface,
//       body: Padding(
//         padding: const EdgeInsets.only(top: 20),
//         child: Column(
//           children: [
//             //Display messages
//             Expanded(child: _buildMessageList()),

//             //User input
//             _buildUserInput()
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildMessageList() {
//     String senderID = authService.getCurrentUser()!.uid;
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 5),
//       child: StreamBuilder(
//         stream: chatService.getMessages(widget.recieverID, senderID),
//         builder: (context, snapshot) {
//           //Error
//           if (snapshot.hasError) {
//             return const Text("Error");
//           }

//           //loading
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Text("Loading messages...");
//           }

//           WidgetsBinding.instance.addPostFrameCallback((_) {
//             if (scrollController.hasClients) {
//               scrollController
//                   .jumpTo(scrollController.position.maxScrollExtent);
//             }
//           });

//           // List of messages
//           List<Widget> messageList = snapshot.data!.docs
//               .map<Widget>((doc) => _buildMessageItem(doc))
//               .toList();

//           // Add the header text at the beginning
//           messageList.insert(
//               0,
//               const Padding(
//                 padding: EdgeInsets.all(20),
//                 child: Center(
//                   child: Text(
//                     "No messages yet. Start the conversation!",
//                     style:
//                         TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
//                   ),
//                 ),
//               ));

//           return ListView(
//             controller: scrollController,
//             children: messageList,
//           );
//         },
//       ),
//     );
//   }

//   //Build message item
//   Widget _buildMessageItem(DocumentSnapshot doc) {
//     Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

//     //Is current user
//     bool isCurrentUser = data['senderID'] == authService.getCurrentUser()!.uid;

//     print(
//         'Building message item: ${data["message"]}, isCurrentUser: $isCurrentUser');

//     //Aligne messages to left side if sender is current user, otherwise left
//     var aligment = isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

//     return Container(
//         alignment: aligment,
//         child: Column(
//           crossAxisAlignment:
//               isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//           children: [
//             ChatBubble(
//               message: data["message"],
//               isCurrentUser: isCurrentUser,
//               timestamp: data['timestamp'],
//             ),
//           ],
//         ));
//   }

//   //Build message input
//   Widget _buildUserInput() {
//     return Padding(
//       padding: const EdgeInsets.only(
//         bottom: 20,
//       ),
//       child: Row(
//         children: [
//           //Message field
//           Expanded(
//               child: Padding(
//             padding: const EdgeInsets.only(left: 20, right: 10),
//             child: ChatInput(
//               hintText: "Message...",
//               obscureText: false,
//               controller: _messageController,
//               focusNode: focusNode,
//               onMediaUpload: () => handleMediaUpload(ImageSource.gallery, true),
//               customColor: Theme.of(context).colorScheme.primary,
//             ),
//           )),

//           //Send button
//           Container(
//             decoration: BoxDecoration(
//                 color: Theme.of(context).colorScheme.secondary,
//                 shape: BoxShape.circle),
//             margin: EdgeInsets.only(right: 20),
//             child: IconButton(
//               onPressed: () => sendMessage(_messageController.text),
//               icon: const Icon(
//                 Icons.arrow_upward_rounded,
//                 color: Colors.white,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }



