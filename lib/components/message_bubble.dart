import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:googleapis/androidenterprise/v1.dart' as androidenterprise;
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;
  final Timestamp timestamp;
  final Function onImageLoaded;

  const ChatBubble(
      {super.key,
      required this.message,
      required this.isCurrentUser,
      required this.timestamp,
      required this.onImageLoaded});

  @override
  Widget build(BuildContext context) {
    // bool to check if the message has media
    bool isMediaMessage = message.startsWith('http');

    return Align(
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
            isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.8,
            ),
            child: Container(
              padding: isMediaMessage
                  ? const EdgeInsets.all(2)
                  : const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: isMediaMessage
                    ? BorderRadius.circular(26)
                    : isCurrentUser
                        ? const BorderRadius.only(
                            topLeft: Radius.circular(26),
                            topRight: Radius.circular(26),
                            bottomLeft: Radius.circular(26),
                            bottomRight: Radius.circular(8),
                          )
                        : const BorderRadius.only(
                            topLeft: Radius.circular(26),
                            topRight: Radius.circular(26),
                            bottomLeft: Radius.circular(8),
                            bottomRight: Radius.circular(26),
                          ),
                color: isMediaMessage
                    ? Theme.of(context).colorScheme.primary
                    : isCurrentUser
                        ? const Color.fromARGB(255, 1, 208, 32)
                        : const Color.fromARGB(255, 58, 58, 58),
              ),
              child: isMediaMessage
                  ? _buildMediaMessage(context)
                  : _buildTextMessage(),
            ),
          ),
        ],
      ),
    );
  }

  // Widget for the Media message
  Widget _buildMediaMessage(BuildContext context) {
    //Set the width and height for the placedholder
    double imageWidth = MediaQuery.of(context).size.width * 0.8;

    return GestureDetector(
      onTap: () => showFullImageModal(context, message),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(26),
            child: CachedNetworkImage(
              imageUrl: message,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                width: imageWidth,
                height: imageWidth,
                color: Colors.grey[300],
                child: Center(child: CircularProgressIndicator()),
              ),
              errorWidget: (context, url, error) => Container(
                width: imageWidth,
                height: imageWidth,
                color: Colors.grey[300],
                child: const Center(
                  child: Icon(Icons.error, color: Colors.red),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.all(4),
              child: Text(
                _formatTimestamp(timestamp),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Build a widget for text messages
  Widget _buildTextMessage() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Text(
            message,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600),
            softWrap: true,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Text(
            _formatTimestamp(timestamp),
            style: const TextStyle(
              color: Color.fromARGB(194, 255, 255, 255),
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  // Helper method to format the timestamp
  String _formatTimestamp(Timestamp timestamp) {
    DateTime date = timestamp.toDate();
    return DateFormat('hh:mm a').format(date);
  }

  //Show image in fullscren
  void showFullImageModal(BuildContext context, String imageUrl) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                Icons.close_rounded,
                color: Colors.white,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.download_rounded, color: Colors.white),
                onPressed: () {
                  downloadImage(context, imageUrl);
                },
              ),
            ],
          ),
          backgroundColor: Colors.black, // Set the background to black
          body: GestureDetector(
            child: Center(
              child: InteractiveViewer(
                panEnabled: true, // Enable image panning
                boundaryMargin: EdgeInsets.all(20), // Margin around the image
                minScale: 0.5, // Minimum zoom scale
                maxScale: 4, // Maximum zoom scale
                child: Image.network(
                  imageUrl,
                  fit:
                      BoxFit.contain, // Ensure the image maintains aspect ratio
                ),
              ),
            ),
          ),
        );
      },
    ));
  }

  Future<void> downloadImage(BuildContext context, String imageUrl) async {
    // Check permission to write to storage
    PermissionStatus permission =
        await Permission.manageExternalStorage.request();

    if (permission.isGranted) {
      try{
     // Get the directory to save the file
      Directory? downloadDir = await getExternalStorageDirectory();

      // Specify the file name and path
      String fileName = imageUrl.split('/').last;
      String savePath = '${downloadDir!.path}/$fileName';

      //TODO FIX NOT SAVING TO GALLERY

      Dio dio = Dio();

      await dio.download(imageUrl, savePath);
 

      }catch(e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Sorry, something went wrong"))
        );
      }
      
    } else {
      // Permission denied
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Storage permission denied")),
      );

      openAppSettings();
    }
  }
}
