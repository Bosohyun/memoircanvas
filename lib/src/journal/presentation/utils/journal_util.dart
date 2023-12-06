import 'package:http/http.dart' as http;
import 'dart:typed_data';

Future<Uint8List> fetchImageBytes(String imageUrl) async {
  final response = await http.get(Uri.parse(imageUrl));
  return response.bodyBytes;
}
