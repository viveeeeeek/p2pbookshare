// ignore_for_file: library_private_types_in_public_api

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:p2pbookshare/extras/img_cache_handler.dart';

class CachedBookCoverImg extends StatefulWidget {
  final String bookCoverImgUrl;

  const CachedBookCoverImg({
    super.key,
    required this.bookCoverImgUrl,
  });

  @override
  _CachedBookCoverImgState createState() => _CachedBookCoverImgState();
}

class _CachedBookCoverImgState extends State<CachedBookCoverImg> {
  // late Future<File?> _cachedFileFuture;

  // @override
  // void initState() {
  //   super.initState();
  //   _cachedFileFuture =
  //       CacheImageHandler.cacheAndRetrieveImage(widget.bookCoverImgUrl);
  // }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<File?>(
      // future: _cachedFileFuture,
      future: CacheImageHandler.cacheAndRetrieveImage(widget.bookCoverImgUrl),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            height: 200,
            width: 150,
            color: Colors.transparent,
          );
        } else if (snapshot.hasError || snapshot.data == null) {
          return SizedBox(
            height: 170,
            width: 130,
            child: Container(
              color: Colors.red,
              child: const Center(
                child: Text(
                  'Failed to load image',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          );
        } else {
          return SizedBox(
            height: 200,
            width: 150,
            child: Image.file(
              snapshot.data!,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.red,
              ),
            ),
          );
        }
      },
    );
  }
}
