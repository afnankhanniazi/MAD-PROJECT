import 'package:flutter/material.dart';

class WorldTimeScreen extends StatelessWidget {
  const WorldTimeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Static data for World Time
    final List<Map<String, String>> worldTimes = [
      {'city': 'New York', 'time': '13:39 PM'},
      {'city': 'London', 'time': '18:39 PM'},
      {'city': 'Tokyo', 'time': '02:39 AM'},
      {'city': 'Sydney', 'time': '03:39 AM'},
      {'city': 'Dubai', 'time': '21:39 PM'},
      {'city': 'Paris', 'time': '19:39 PM'},
      {'city': 'Islamabad', 'time': '23:39 PM'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('World Time')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: worldTimes.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            elevation: 4,
            child: ListTile(
              leading: const Icon(Icons.access_time_filled, color: Colors.indigo, size: 40),
              title: Text(
                worldTimes[index]['city']!,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              subtitle: Text("Today, ${worldTimes[index]['time']}"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ),
          );
        },
      ),
    );
  }
}