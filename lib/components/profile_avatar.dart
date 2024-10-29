import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar(
      {super.key, required this.imageUrl, required this.radius});

  final String? imageUrl;
  final double radius;

  @override
  Widget build(BuildContext context) {

    ImageProvider imageProvider;  

    if(imageUrl != null){
      imageProvider = CachedNetworkImageProvider(imageUrl!);
    }else {
      imageProvider = const NetworkImage(
      'https://t4.ftcdn.net/jpg/05/49/98/39/360_F_549983970_bRCkYfk0P6PP5fKbMhZMIb07mCJ6esXL.jpg'
      );
    }

      return CircleAvatar(
      radius: radius,
      backgroundImage: imageProvider,
    );
    }
 }
