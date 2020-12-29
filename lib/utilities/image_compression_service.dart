import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class ImageCompressionService {
  static Future<File> getCompressedImage(
    ImageSource imageSource, {
    String targetPath,
    int targetSize = 50000,
  }) async {
    try {
      final PickedFile imageFile =
          await ImagePicker().getImage(source: imageSource);

      // If no image was selected then return null;
      if (imageFile == null) return null;

      // get original file size
      final File file = File(imageFile.path);
      final int size = file.lengthSync();

      // if original file size is already less than targetSize then return file.
      if (size <= targetSize) return file;

      // calculate quality ratio to get target file size.
      final int qualityRatio = ((targetSize / size) * 100).ceil();

      debugPrint(
          "size => $size , desiredSize => $targetSize , getQualityRatio => $qualityRatio , ${file.absolute.path}");

      // if target path is not given, get temp path.
      final Directory dir = targetPath ?? await getTemporaryDirectory();
      // get file name to create unique path for updated file.
      final String fileName = basename(file.path);

      // update file with calculated parameters.
      final File updatedFile = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        dir.path + "/$fileName.jpeg",
        quality: qualityRatio,
        rotate: 0,
      );

      // check new file size.
      final int newSize = updatedFile.lengthSync();

      debugPrint("updated size => $newSize");
      // return compressed file.
      return updatedFile;
    } catch (e) {
      debugPrint("caught error => $e");
      return null;
    }
  }
}
