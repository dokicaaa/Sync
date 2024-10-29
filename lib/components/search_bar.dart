import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MySearchBar extends StatelessWidget {
  final TextEditingController searchController;
  const MySearchBar({super.key, required this.searchController});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      child: TextField(
        decoration: InputDecoration(
            hintText: 'Search',
            prefixIcon: Icon(Icons.search_rounded),
            filled: true,
            fillColor: Theme.of(context).colorScheme.primary,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none)),
        onChanged: (value) {
          // The state of the parent widget (HomePage) needs to be refreshed when text changes
          searchController.text = value;
          (context as Element).markNeedsBuild();
        },
      ),
    );
  }
}
