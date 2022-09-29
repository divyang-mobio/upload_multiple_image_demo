import 'package:firebase_storage/firebase_storage.dart';

class FirebaseCalling {
  static Future<List<String>> listAll(String path) async {
    final result = await FirebaseStorage.instance.ref(path).listAll();
    final urls = await _getLink(result.items);
    return urls;
  }

  static Future<List<String>> _getLink(List<Reference> items) =>
      Future.wait(items.map((e) => e.getDownloadURL()).toList());
}
