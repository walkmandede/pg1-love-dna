// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../models/love_code_result.dart';

// class FirestoreService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   static const String _sessionsCollection = 'sessions';

//   Future<String> saveResult(LoveCodeResult result) async {
//     try {
//       final docRef = await _firestore.collection(_sessionsCollection).add(result.toJson());
//       return docRef.id;
//     } catch (e) {
//       throw Exception('Failed to save result: $e');
//     }
//   }

//   Future<void> saveResultWithId(LoveCodeResult result) async {
//     try {
//       await _firestore.collection(_sessionsCollection).doc(result.sessionId).set(result.toJson());
//     } catch (e) {
//       throw Exception('Failed to save result: $e');
//     }
//   }

//   Future<Map<String, dynamic>?> getResult(String sessionId) async {
//     try {
//       final doc = await _firestore.collection(_sessionsCollection).doc(sessionId).get();
//       return doc.data();
//     } catch (e) {
//       throw Exception('Failed to get result: $e');
//     }
//   }
// }
