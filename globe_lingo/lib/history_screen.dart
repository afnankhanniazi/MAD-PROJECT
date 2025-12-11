import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart'; // For formatting time

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text("Activity Log")),
      body: user == null
          ? const Center(child: Text("Please login to see history"))
          : StreamBuilder(
              // Ask Database for items where 'userId' matches the current user
              stream: FirebaseFirestore.instance
                  .collection('history')
                  .where('userId', isEqualTo: user.uid)
                  .orderBy('timestamp', descending: true) // Newest first
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                // 1. Loading State
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                // 2. Error State
                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }

                // 3. Empty State
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No history found yet."));
                }

                // 4. Show Data
                return ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var data = snapshot.data!.docs[index];
                    
                    // Format Timestamp
                    Timestamp? t = data['timestamp'] as Timestamp?;
                    String timeString = t != null 
                        ? DateFormat('MMM d, h:mm a').format(t.toDate()) 
                        : "Just now";

                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.indigo.withOpacity(0.1),
                          child: _getIconForAction(data['action']),
                        ),
                        title: Text(data['action'], style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(data['details']),
                        trailing: Text(timeString, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }

  // Helper to pick icons based on the action
  Icon _getIconForAction(String action) {
    if (action.contains("Login")) return const Icon(Icons.login, color: Colors.green);
    if (action.contains("Translation")) return const Icon(Icons.translate, color: Colors.orange);
    if (action.contains("Currency")) return const Icon(Icons.attach_money, color: Colors.purple);
    return const Icon(Icons.history, color: Colors.blue);
  }
}