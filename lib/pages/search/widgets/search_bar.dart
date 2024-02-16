import 'package:flutter/material.dart';

Widget searchbookSearchBar(String hintText) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
    child: Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: TextField(
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
          prefixIcon: const Icon(Icons.search),
        ),
      ),
    ),
  );
}
