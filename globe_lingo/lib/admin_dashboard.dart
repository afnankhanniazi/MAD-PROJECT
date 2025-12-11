import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'main.dart'; // Import main to access LoginScreen

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Increased to 3 tabs
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Admin Panel 🛡️"),
          backgroundColor: Colors.black87,
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.analytics), text: "Analytics"), // NEW
              Tab(icon: Icon(Icons.people), text: "User Control"),
              Tab(icon: Icon(Icons.message), text: "Feedback"),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
              },
            )
          ],
        ),
        body: const TabBarView(
          children: [
            AnalyticsTab(), // NEW
            UsersList(),
            FeedbackList(),
          ],
        ),
      ),
    );
  }
}

// --- TAB 1: ANALYTICS (STATS) ---
class AnalyticsTab extends StatelessWidget {
  const AnalyticsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('history').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        
        var docs = snapshot.data!.docs;
        
        // Calculate Stats
        int totalActions = docs.length;
        int translations = docs.where((d) => d['action'].toString().contains('Translation')).length;
        int voiceChats = docs.where((d) => d['action'].toString().contains('Voice')).length;
        int users = docs.map((d) => d['userEmail'].toString()).toSet().length;

        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("App Performance", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              _buildStatCard("Total Active Users", "$users", Icons.person, Colors.blue),
              _buildStatCard("Total Activities", "$totalActions", Icons.show_chart, Colors.purple),
              Row(
                children: [
                  Expanded(child: _buildStatCard("Translations", "$translations", Icons.translate, Colors.orange)),
                  Expanded(child: _buildStatCard("Voice Chats", "$voiceChats", Icons.mic, Colors.red)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatCard(String title, String count, IconData icon, Color color) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16, right: 8),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 10),
            Text(count, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
            Text(title, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

// --- TAB 2: USER CONTROL (BAN SYSTEM) ---
class UsersList extends StatelessWidget {
  const UsersList({super.key});

  Future<void> _banUser(BuildContext context, String email) async {
    bool confirm = await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Ban User?"),
        content: Text("Are you sure you want to block $email? They will be unable to login."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("Cancel")),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text("Ban", style: TextStyle(color: Colors.red))),
        ],
      ),
    ) ?? false;

    if (confirm) {
      // Add to Blacklist Collection
      await FirebaseFirestore.instance.collection('banned_users').add({
        'email': email,
        'bannedAt': FieldValue.serverTimestamp(),
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$email has been banned.")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('history').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        
        final allDocs = snapshot.data!.docs;
        // Filter out Admin from the list
        final uniqueEmails = allDocs
            .map((e) => e['userEmail'].toString())
            .toSet()
            .where((email) => email != "admin@admin.com") 
            .toList();

        return ListView.builder(
          itemCount: uniqueEmails.length,
          itemBuilder: (context, index) {
            String email = uniqueEmails[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: ListTile(
                leading: CircleAvatar(child: Text(email[0].toUpperCase())),
                title: Text(email),
                subtitle: const Text("Active User"),
                trailing: IconButton(
                  icon: const Icon(Icons.block, color: Colors.red),
                  onPressed: () => _banUser(context, email),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

// --- TAB 3: FEEDBACK (Keep as is) ---
class FeedbackList extends StatelessWidget {
  const FeedbackList({super.key});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('feedback').orderBy('timestamp', descending: true).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: Text("Loading..."));
        var docs = snapshot.data!.docs;
        if (docs.isEmpty) return const Center(child: Text("No feedback yet."));
        
        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, index) {
            var data = docs[index];
            return Card(
              margin: const EdgeInsets.all(8),
              child: ListTile(
                leading: const Icon(Icons.report, color: Colors.orange),
                title: Text(data['text']),
                subtitle: Text("From: ${data['userEmail']}"),
              ),
            );
          },
        );
      },
    );
  }
}