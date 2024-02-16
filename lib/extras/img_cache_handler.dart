import 'dart:io';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:simple_logger/simple_logger.dart';

class CacheImageHandler {
  static SimpleLogger logger = SimpleLogger();

  //! cache and store images
  static Future<File?> cacheAndRetrieveImage(String imageUrl) async {
    try {
      final file = await DefaultCacheManager().getSingleFile(imageUrl);
      if (await file.exists()) {
        logger.info('💥ImageCover loaded from cache');
        return file;
      } else {
        await DefaultCacheManager().downloadFile(imageUrl);
        logger.info('💥ImageCover downloaded');
        return await DefaultCacheManager().getSingleFile(imageUrl);
      }
    } catch (e) {
      logger.info('❌ImageCover loading error');
      return null;
    }
  }
}
