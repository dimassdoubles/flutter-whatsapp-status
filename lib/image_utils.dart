import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class ImageUtils {
  ImageUtils._();

  static Future<File> uint8ListToFile(Uint8List uint8List) async {
    try {
      final tempDir = await getTemporaryDirectory();
      File file = await File('${tempDir.path}/image.png').create();
      file.writeAsBytesSync(uint8List);

      return file;
    } catch (e) {
      debugPrint("Gagal convert Uint8List ke File: $e");
      rethrow;
    }
  }
}
