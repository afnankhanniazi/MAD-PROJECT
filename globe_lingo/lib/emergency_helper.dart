import 'package:flutter/material.dart';
import 'emergency_data.dart'; // Importing the big list

class EmergencyHelperScreen extends StatefulWidget {
  const EmergencyHelperScreen({super.key});

  @override
  State<EmergencyHelperScreen> createState() => _EmergencyHelperScreenState();
}

class _EmergencyHelperScreenState extends State<EmergencyHelperScreen> {
  // We don't initialize it here anymore to avoid the crash
  Map<String, String>? selectedCountry;

  @override
  void initState() {
    super.initState();
    // ERROR WAS HERE: We removed the .sort() line because the list is read-only.
    
    // Just pick the first country safely
    if (globalEmergencyData.isNotEmpty) {
      selectedCountry = globalEmergencyData[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    // Safety check: If list is empty or something went wrong, show loading
    if (selectedCountry == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Helper'),
        backgroundColor: Colors.redAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              "Select your location:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.redAccent),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<Map<String, String>>(
                  isExpanded: true,
                  value: selectedCountry,
                  items: globalEmergencyData.map((data) {
                    return DropdownMenuItem(
                      value: data,
                      child: Text(data['country']!),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCountry = value!;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 40),
            
            // Emergency Cards
            _buildEmergencyCard("Police", selectedCountry!['police']!, Icons.local_police, Colors.blue),
            const SizedBox(height: 15),
            _buildEmergencyCard("Ambulance", selectedCountry!['ambulance']!, Icons.medical_services, Colors.red),
            const SizedBox(height: 15),
            _buildEmergencyCard("Fire Dept", selectedCountry!['fire']!, Icons.local_fire_department, Colors.orange),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyCard(String title, String number, IconData icon, Color color) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        trailing: Text(
          number,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
        ),
      ),
    );
  }
}