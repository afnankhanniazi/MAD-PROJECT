import 'package:flutter/material.dart';

class CountryGuideScreen extends StatefulWidget {
  const CountryGuideScreen({super.key});

  @override
  State<CountryGuideScreen> createState() => _CountryGuideScreenState();
}

class _CountryGuideScreenState extends State<CountryGuideScreen> {
  // Static data for the Country Guide
  final List<Map<String, String>> countries = [
    {
      'name': 'Spain',
      'language': 'Spanish',
      'capital': 'Madrid',
      'currency': 'Euro (€)',
      'fact': 'Spain has a festival called "La Tomatina" where people throw tomatoes at each other!',
    },
    {
      'name': 'France',
      'language': 'French',
      'capital': 'Paris',
      'currency': 'Euro (€)',
      'fact': 'The Eiffel Tower can grow more than 15 cm taller during the summer due to heat expansion.',
    },
    {
      'name': 'Germany',
      'language': 'German',
      'capital': 'Berlin',
      'currency': 'Euro (€)',
      'fact': 'There are over 1,000 kinds of sausages in Germany!',
    },
    {
      'name': 'Pakistan',
      'language': 'Urdu',
      'capital': 'Islamabad',
      'currency': 'Rupee (PKR)',
      'fact': 'Pakistan makes more than 50% of the worlds hand-sewn footballs.',
    },
    {
      'name': 'China',
      'language': 'Chinese',
      'capital': 'Beijing',
      'currency': 'Yuan (¥)',
      'fact': 'The Great Wall of China is the longest wall in the world, stretching over 13,000 miles.',
    },
  ];

  // Default selection
  Map<String, String> selectedCountry = {};

  @override
  void initState() {
    super.initState();
    // Start with the first country in the list
    selectedCountry = countries[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Country Info Guide')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Select a Country:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            
            // Dropdown to choose country
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<Map<String, String>>(
                  isExpanded: true,
                  value: selectedCountry,
                  items: countries.map((country) {
                    return DropdownMenuItem(
                      value: country,
                      child: Text(country['name']!),
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
            const SizedBox(height: 30),

            // Info Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        selectedCountry['name']!,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    const Divider(height: 30),
                    _buildInfoRow(Icons.language, "Language:", selectedCountry['language']!),
                    const SizedBox(height: 15),
                    _buildInfoRow(Icons.location_city, "Capital:", selectedCountry['capital']!),
                    const SizedBox(height: 15),
                    _buildInfoRow(Icons.money, "Currency:", selectedCountry['currency']!),
                    const SizedBox(height: 25),
                    const Text(
                      "Did you know?",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      selectedCountry['fact']!,
                      style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget to build rows of info
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.indigo, size: 20),
        const SizedBox(width: 10),
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 5),
        Expanded(child: Text(value)),
      ],
    );
  }
}