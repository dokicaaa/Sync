import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderID;
  final String senderEmail;
  final String recieverID;
  final String message;
  final Timestamp timestamp;

  Message({
    required this.senderID,
    required this.senderEmail,
    required this.recieverID,
    required this.message,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderID': senderID,
      'senderEmail': senderEmail,
      'recieverID': recieverID,
      'message': message,
      'timestamp': timestamp,
    };
  }

   factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      senderID: map['senderID'],
      senderEmail: map['senderEmail'],
      recieverID: map['recieverID'],
      message: map['message'],
      timestamp: map['timestamp'],
    );
  }
}
