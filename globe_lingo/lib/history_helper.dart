import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HistoryHelper {
  // This function adds an entry to the database
  static Future<void> addToHistory(String actionTitle, String details) async {
    final user = FirebaseAuth.instance.currentUser;
    
    // Only save if a user is actually logged in
    if (user != null) {
      await FirebaseFirestore.instance.collection('history').add({
        'userId': user.uid,              // Who did it?
        'userEmail': user.email,         // Email for reference
        'action': actionTitle,           // What did they do? (e.g., "Login", "Translation")
        'details': details,              // Extra info (e.g., "USD to EUR", "Hello -> Hola")
        'timestamp': FieldValue.serverTimestamp(), // Exact time
      });
    }
  }
}