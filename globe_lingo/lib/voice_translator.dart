import 'package:flutter/material.dart';

class VoiceTranslatorScreen extends StatefulWidget {
  const VoiceTranslatorScreen({super.key});

  @override
  State<VoiceTranslatorScreen> createState() => _VoiceTranslatorScreenState();
}

class _VoiceTranslatorScreenState extends State<VoiceTranslatorScreen> {
  bool isListening = false;
  String textInput = "Press the mic to start speaking...";
  String translatedOutput = "";

  // Mock function to simulate listening and translating
  void toggleListening() async {
    setState(() {
      isListening = true;
      textInput = "Listening...";
    });

    // Simulate a 2-second delay for "listening"
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    setState(() {
      isListening = false;
      textInput = "Hello, how are you?"; // Simulated voice input
      translatedOutput = "Hola, ¿cómo estás?"; // Simulated translation
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Voice Conversation')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // --- TOP SECTION: What you said ---
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "You said:",
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      textInput,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),

            // --- MIDDLE SECTION: Microphone Button ---
            GestureDetector(
              onTap: toggleListening,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  color: isListening ? Colors.red : Colors.indigo,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: (isListening ? Colors.red : Colors.indigo).withOpacity(0.4),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Icon(
                  isListening ? Icons.stop : Icons.mic,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(isListening ? "Listening..." : "Tap to Speak"),

            const SizedBox(height: 20),

            // --- BOTTOM SECTION: Translated Result ---
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.indigo.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.indigo.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Translation (Spanish):",
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo),
                        ),
                        IconButton(
                          icon: const Icon(Icons.volume_up, color: Colors.indigo),
                          onPressed: () {
                            // Placeholder for Text-to-Speech logic
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Playing audio... (Simulation)")),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      translatedOutput.isEmpty ? "..." : translatedOutput,
                      style: const TextStyle(
                        fontSize: 22, 
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                      ),
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
}