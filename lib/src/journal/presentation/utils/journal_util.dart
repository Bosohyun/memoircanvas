import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';

class JournalUtils {
  const JournalUtils._();

  static Future<Uint8List> fetchImageBytes({required String imageUrl}) async {
    final response = await http.get(Uri.parse(imageUrl));
    return response.bodyBytes;
  }

  static openTempJournal(BuildContext context, {bool dismissble = true}) {
    showDialog(
      context: context,
      barrierDismissible: dismissble,
      builder: (context) => WillPopScope(
        onWillPop: () async => dismissble,
        child: Dialog(
          insetPadding: const EdgeInsets.all(10),
          backgroundColor: Colors.transparent,
          child: Container(
            height: 200,
            width: 200,
            color: Colors.orangeAccent,
          ),
        ),
      ),
    );
  }

  static Future<XFile?> pickMedia({
    required bool isGallery,
  }) async {
    final source = isGallery ? ImageSource.gallery : ImageSource.camera;
    final pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile == null) return null;

    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: pickedFile.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
      ],
    );

    if (croppedFile == null) {
      return null;
    } else {
      return XFile(croppedFile.path);
    }
  }
}
