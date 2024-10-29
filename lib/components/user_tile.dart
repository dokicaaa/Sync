import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:portfolio_app/components/profile_avatar.dart';

class UserTile extends StatelessWidget {
  final String text;
  final void Function()? onTap;
  final String? profilePictureUrl;
  final String? lastMessage;
  final bool isLastMessageFromCurrentUser;
  final Timestamp? lastMessageTimestamp;

  const UserTile(
      {super.key,
      required this.onTap,
      required this.text,
      required this.profilePictureUrl,
      required this.lastMessage,
      required this.isLastMessageFromCurrentUser,
      required this.lastMessageTimestamp});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 18),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(8)),
        child: Row(
          children: [
            //Profile avatar next to
            ProfileAvatar(imageUrl: profilePictureUrl, radius: 32),

            const SizedBox(
              width: 20,
            ),

            //User name
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          text,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.tertiary,
                              fontWeight: FontWeight.w600,
                              fontSize: 16),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      //Display last message time
                      if (lastMessageTimestamp != null)
                        Text(
                          ' ${DateFormat('hh:mm a').format(lastMessageTimestamp!.toDate())}',
                          style: const TextStyle(
                            color: Color.fromARGB(255, 0, 129, 19),
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        )
                    ],
                  ),

                  const SizedBox(height: 5),

                  //Last Message
                  Text(
                    isLastMessageFromCurrentUser
                        ? 'Sent'
                        : lastMessage ?? "No messages yet",
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w200,
                        color: Color.fromARGB(255, 172, 172, 172)),
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
