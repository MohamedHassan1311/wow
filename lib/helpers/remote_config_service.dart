import 'package:cloud_firestore/cloud_firestore.dart';

class AppConfig {
  static bool isIosFlag = true;

  static Future<void> loadConfig() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('ISIOS')
          .doc('ios')
          .get();

      if (doc.exists && doc.data() != null) {
        final data = doc.data() as Map<String, dynamic>;
        isIosFlag = data['ios'] ?? false;
      }
    } catch (e) {
      print("Failed to load ISIOS from Firestore: $e");
      isIosFlag = false; // fallback
    }
  }
}
