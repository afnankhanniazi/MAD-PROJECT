import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserFeedbackScreen extends StatefulWidget {
  const UserFeedbackScreen({super.key});

  @override
  State<UserFeedbackScreen> createState() => _UserFeedbackScreenState();
}

class _UserFeedbackScreenState extends State<UserFeedbackScreen> {
  final _controller = TextEditingController();
  bool _isSubmitting = false;

  Future<void> _sendFeedback() async {
    if (_controller.text.isEmpty) return;
    
    setState(() => _isSubmitting = true);
    final user = FirebaseAuth.instance.currentUser;

    await FirebaseFirestore.instance.collection('feedback').add({
      'text': _controller.text,
      'userEmail': user?.email ?? 'Anonymous',
      'timestamp': FieldValue.serverTimestamp(),
      'status': 'Pending', // Admin can mark this as 'Read' later
    });

    if (mounted) {
      setState(() => _isSubmitting = false);
      _controller.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Feedback sent to Admin!")),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Contact Support")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text("Tell us what is wrong or suggest a feature:", style: TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            TextField(
              controller: _controller,
              maxLines: 5,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Type your message here...",
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _isSubmitting ? null : _sendFeedback,
              icon: const Icon(Icons.send),
              label: const Text("Submit to Admin"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
            )
          ],
        ),
      ),
    );
  }
}