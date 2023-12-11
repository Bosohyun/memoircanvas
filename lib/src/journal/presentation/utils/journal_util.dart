import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';

import 'package:memoircanvas/core/utils/constants.dart';
import 'package:memoircanvas/core/utils/core_utils.dart';

class JournalUtils {
  const JournalUtils._();

  static Future<Uint8List> fetchImageBytes({required String imageUrl}) async {
    final response = await http.get(Uri.parse(imageUrl));
    return response.bodyBytes;
  }

  static Future<String?> generateImage(
      {required String journal, required BuildContext context}) async {
    final uri = Uri.parse('https://api.openai.com/v1/images/generations');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $openAIAPI',
    };
    final body = jsonEncode(
        {"model": "dall-e-3", "prompt": journal, "n": 1, "size": "1024x1024"});
    final response = await http.post(uri, headers: headers, body: body);
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);

      return responseData['data'][0]['url'];
    } else {
      if (context.mounted) {
        CoreUtils.showSnackBar(context, 'Failed to generate image');
      }
      return null;
    }
  }

  static openTempJournal(BuildContext context, {bool dismissble = true}) {
    showDialog(
      context: context,
      barrierDismissible: dismissble,
      builder: (context) => WillPopScope(
        onWillPop: () async => dismissble,
        child: Dialog(
          insetPadding: EdgeInsets.all(10),
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
}
