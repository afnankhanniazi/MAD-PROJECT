import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:translator/translator.dart';
import 'history_helper.dart'; // Make sure this matches your file name

class VoiceTranslatorScreen extends StatefulWidget {
  const VoiceTranslatorScreen({super.key});

  @override
  State<VoiceTranslatorScreen> createState() => _VoiceTranslatorScreenState();
}

class _VoiceTranslatorScreenState extends State<VoiceTranslatorScreen> {
  // 1. Setup the Engines
  late stt.SpeechToText _speech;
  late FlutterTts _flutterTts;
  final GoogleTranslator _translator = GoogleTranslator();

  bool _isListening = false;
  String _textInput = "Press the mic and start speaking...";
  String _translatedOutput = "";
  String _selectedLocaleId = 'es-ES'; // Default to Spanish

  // Language options for speaking
  final Map<String, String> _languages = {
    'Spanish': 'es-ES',
    'French': 'fr-FR',
    'German': 'de-DE',
    'Chinese': 'zh-CN',
    'Urdu': 'ur-PK',
  };

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _flutterTts = FlutterTts();
  }

  // 2. The Listening Function
  Future<void> _listen() async {
    if (!_isListening) {
      // Start Listening
      bool available = await _speech.initialize();
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) async {
            setState(() {
              _textInput = val.recognizedWords;
            });
            
            // If the user stops speaking (final result), translate it
            if (val.hasConfidenceRating && val.confidence > 0) {
               _translateAndSpeak(val.recognizedWords);
            }
          },
        );
      }
    } else {
      // Stop Listening
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  // 3. The Translate & Speak Function
  Future<void> _translateAndSpeak(String text) async {
    if (text.isEmpty) return;

    // Get the target language code (e.g., 'es' from 'es-ES')
    String targetLang = _selectedLocaleId.split('-')[0];

    // Translate
    var translation = await _translator.translate(text, to: targetLang);
    
    setState(() {
      _translatedOutput = translation.text;
    });

    // Speak
    await _flutterTts.setLanguage(_selectedLocaleId);
    await _flutterTts.setPitch(1.0);
    await _flutterTts.speak(translation.text);

    // Save to History
    HistoryHelper.addToHistory(
      "Voice Chat", 
      "Spoke: '$text' -> Heard: '${translation.text}'"
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Voice Conversation')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Language Selector
            DropdownButton<String>(
              value: _languages.entries.firstWhere((e) => e.value == _selectedLocaleId).key,
              items: _languages.keys.map((String key) {
                return DropdownMenuItem<String>(
                  value: key,
                  child: Text(key),
                );
              }).toList(),
              onChanged: (val) {
                setState(() {
                  _selectedLocaleId = _languages[val]!;
                });
              },
            ),
            const SizedBox(height: 30),
            
            // What you said
            Text(
              _textInput,
              style: const TextStyle(fontSize: 20, color: Colors.black87),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            
            // The Translation
            Text(
              _translatedOutput,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.indigo),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      // The Big Mic Button
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: _isListening,
        glowColor: Colors.red,
        endRadius: 75.0,
        duration: const Duration(milliseconds: 2000),
        repeat: true,
        showTwoGlows: true,
        child: FloatingActionButton(
          onPressed: _listen,
          backgroundColor: _isListening ? Colors.red : Colors.indigo,
          child: Icon(_isListening ? Icons.mic : Icons.mic_none, size: 36),
        ),
      ),
    );
  }
}

// Simple Glow Animation Widget (If you don't have the package, we use a simple Container wrapper)
class AvatarGlow extends StatelessWidget {
  final bool animate;
  final Widget child;
  // Ignore other params for this simple version
  const AvatarGlow({super.key, required this.animate, required this.child, required Color glowColor, required double endRadius, required Duration duration, required bool repeat, required bool showTwoGlows});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: animate ? BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: Colors.red.withOpacity(0.5), blurRadius: 20, spreadRadius: 5)
        ]
      ) : null,
      child: child,
    );
  }
}