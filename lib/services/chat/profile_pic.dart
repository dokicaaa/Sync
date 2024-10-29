import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfileService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  //Pick image
  Future<File?> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    return pickedFile != null ? File(pickedFile.path) : null;
  }

  //Upload image for profile picture
  Future<String?> uploadImageAndUpdateProfile(File imageFile) async {
    String? userId = auth.currentUser?.uid;
    if (userId == null) {
      print("[ERROR] No user logged in.");
      return null;
    }

    // Compress the image before uploading
    final compressedImage = await FlutterImageCompress.compressWithFile(
      imageFile.absolute.path,
      minWidth: 250,
      minHeight: 250,
      quality: 60,
    );

    if (compressedImage == null) {
      print("[ERROR] Image compression failed.");
      return null;
    }

    final filePath = 'profileImages/$userId';
    final storageRef = storage.ref().child(filePath);
    final uploadTask = storageRef.putData(compressedImage);

    try {
      await uploadTask;
      final String downloadUrl = await storageRef.getDownloadURL();
      print("[DEBUG] Profile picture uploaded to: $downloadUrl");

      await firestore
          .collection("Users")
          .doc(userId)
          .update({'photoUrl': downloadUrl});
      print("[DEBUG] User profile updated with photoUrl");

      return downloadUrl;
    } catch (e) {
      print("[ERROR] Failed to upload image and update profile: $e");
      return null;
    }
  }

  //Get the current users profile picture
  Future<String?> getProfilePictureUrl() async {
    String? userId = auth.currentUser?.uid;
    if (userId == null) {
      print("[ERROR] No user logged in.");
      return null;
    }

    try {
      DocumentSnapshot userDoc =
          await firestore.collection("Users").doc(userId).get();
      if (userDoc.exists && userDoc['photoUrl'] != null) {
        return userDoc['photoUrl'];
      } else {
        return null;
      }
    } catch (e) {
      debugPrint("[ERROR] Failed to get profile picture URL: $e");
      return null;
    }
  }

  // Get a user's profile picture by their user ID
  Future<String?> getUserProfilePictureUrl(String userId) async {
    try {
      DocumentSnapshot userDoc =
          await firestore.collection("Users").doc(userId).get();
      if (userDoc.exists && userDoc.data() != null) {
        var userData = userDoc.data() as Map<String, dynamic>;
        if (userData.containsKey('photoUrl') &&
            userData['photoUrl'] is String) {
          return userData['photoUrl'];
        }
      }
    } catch (e) {
      debugPrint("[ERROR] Failed to get user profile picture URL: $e");
      return null;
    }
    return null;
  }
}
