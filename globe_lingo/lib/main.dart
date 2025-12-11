import 'package:firebase_core/firebase_core.dart';
import 'history_helper.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'country_guide.dart';
import 'voice_translator.dart';
import 'world_time.dart';
import 'history_screen.dart';
import 'currency_converter.dart';
import 'emergency_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyDpHATJd_9izCvoMpAUdsz5PJobo6czPdA", // From "current_key"
      appId: "1:128101786156:android:b213e02093a9e61633a789", // From "mobilesdk_app_id"
      messagingSenderId: "128101786156", // From "project_number"
      projectId: "globelingo-21142", // From "project_id"
    ),
  );
  
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      theme: ThemeData(primarySwatch: Colors.indigo),
    );
  }
}
// --- SPLASH SCREEN ---
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _controller.forward();

    // Navigate to Login Screen after 6 seconds
    Future.delayed(const Duration(seconds: 6), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor.withOpacity(0.8),
              Theme.of(context).primaryColorLight,
            ],
          ),
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.language,
                          size: 80,
                          color: Colors.indigo,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        "GlobeLingo",
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.5,
                          shadows: [
                            Shadow(
                              offset: Offset(2.0, 2.0),
                              blurRadius: 4.0,
                              color: Color.fromRGBO(0, 0, 0, 0.3),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: const Text(
                          "Your World, Your Language",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      SizedBox(
                        width: 40,
                        height: 40,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white.withOpacity(0.9),
                          ),
                          strokeWidth: 3,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
// --- LOGIN SCREEN (REAL AUTHENTICATION) ---
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLogin = true;
  bool isLoading = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> handleAuth() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      if (isLogin) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
        
        // --- ADD THIS LINE ---
        await HistoryHelper.addToHistory("Login", "User logged in successfully"); 
        
      } else {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password); 
        // --- ADD THIS LINE ---
        await HistoryHelper.addToHistory("New Account", "User created a new account");
      }
      // ... navigation code ...
      
      // If successful, navigate to Home
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    } on FirebaseAuthException catch (e) {
      // Show error message (like "Wrong password" or "Email in use")
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message ?? "Authentication failed"), 
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isLogin ? 'Login' : 'Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.language, size: 80, color: Colors.indigo),
            const SizedBox(height: 32),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: isLoading ? null : handleAuth,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: isLoading 
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(
                      isLogin ? 'Login' : 'Sign Up',
                      style: const TextStyle(fontSize: 16),
                    ),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: isLoading ? null : () {
                setState(() {
                  isLogin = !isLogin;
                });
              },
              child: Text(
                isLogin
                    ? "Don't have an account? Sign Up"
                    : "Already have an account? Login",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// --- NEW DASHBOARD (HOME PAGE) ---
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // We use ExtendBodyBehindAppBar to make the gradient cover the top status bar
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("GlobeLingo Hub", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent, // See-through AppBar
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.indigo),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.language, size: 50, color: Colors.white),
                  SizedBox(height: 10),
                  Text("GlobeLingo Menu", style: TextStyle(color: Colors.white, fontSize: 24)),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // THEME: Same Gradient as Splash Screen
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor.withOpacity(0.8),
              Colors.blue.shade300,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Welcome Back!",
                  style: TextStyle(
                    fontSize: 28, 
                    fontWeight: FontWeight.bold, 
                    color: Colors.white
                  ),
                ),
                const Text(
                  "What would you like to do?",
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),
                const SizedBox(height: 30),
                
                // --- THE FEATURE GRID ---
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2, // 2 Columns
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    children: [
                      // 1. Translator
                      _buildMenuCard(context, "Translator", Icons.translate, Colors.orange, const TranslatorScreen()),
                      
                      // 2. Voice Chat
                      _buildMenuCard(context, "Voice Chat", Icons.mic, Colors.red, const VoiceTranslatorScreen()),
                      
                      // 3. Country Info
                      _buildMenuCard(context, "Country Info", Icons.public, Colors.green, const CountryGuideScreen()),
                      
                      // 4. World Time
                      _buildMenuCard(context, "World Time", Icons.access_time, Colors.purple, const WorldTimeScreen()),
                      
                      // 5. Currency
                      _buildMenuCard(context, "Currency", Icons.currency_exchange, Colors.teal, const CurrencyScreen()),
                      
                      // 6. EMERGENCY HELPER (New Unique Feature!)
                      _buildMenuCard(context, "Emergency", Icons.health_and_safety, Colors.redAccent, const EmergencyHelperScreen()),

                      _buildMenuCard(context, "History", Icons.history, Colors.blue, const HistoryScreen()),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper function to build the beautiful buttons
  Widget _buildMenuCard(BuildContext context, String title, IconData icon, Color color, Widget nextPage) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => nextPage));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: color.withOpacity(0.1),
              child: Icon(icon, size: 30, color: color),
            ),
            const SizedBox(height: 15),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16, 
                fontWeight: FontWeight.bold,
                color: Colors.black87
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- NEW TRANSLATOR SCREEN (Moved from old Home Page) ---
class TranslatorScreen extends StatefulWidget {
  const TranslatorScreen({super.key});

  @override
  State<TranslatorScreen> createState() => _TranslatorScreenState();
}

class _TranslatorScreenState extends State<TranslatorScreen> {
  final inputController = TextEditingController();
  String translatedText = "";
  String selectedLanguage = 'es';
  bool isLoading = false;

  final languageMap = {
    'Spanish': 'es',
    'French': 'fr',
    'German': 'de',
    'Urdu': 'ur',
    'Chinese': 'zh-cn',
  };

  Future<void> translateText() async {
    if (inputController.text.isEmpty) return;
    setState(() => isLoading = true);
    
    // Simulate delay
    await Future.delayed(const Duration(seconds: 1)); 
    
    setState(() {
      translatedText = "Translated: ${inputController.text} (Simulation)"; // Or your real logic
      isLoading = false;
      
      // --- ADD THIS LINE ---
      HistoryHelper.addToHistory(
        "Translation ($selectedLanguage)", 
        "${inputController.text} -> $translatedText"
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Text Translator')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: inputController,
              decoration: const InputDecoration(
                labelText: 'Enter text to translate',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedLanguage,
                    decoration: const InputDecoration(
                      labelText: 'Select Language',
                      border: OutlineInputBorder(),
                    ),
                    items: languageMap.entries.map((entry) {
                      return DropdownMenuItem(
                        value: entry.value,
                        child: Text(entry.key),
                      );
                    }).toList(),
                    onChanged: (value) => setState(() => selectedLanguage = value!),
                  ),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: isLoading ? null : translateText,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                  ),
                  child: isLoading ? const CircularProgressIndicator(color: Colors.white) : const Icon(Icons.translate),
                ),
              ],
            ),
            const SizedBox(height: 30),
            if (translatedText.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.indigo.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.indigo.withOpacity(0.3)),
                ),
                child: Text(translatedText, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
              ),
          ],
        ),
      ),
    );
  }
}
// --- KEEP THESE EXISTING SCREENS (Do not delete them if they are below) ---
// If you deleted HistoryScreen or TimeAndCurrencyScreen, paste them back here.
// I will include brief versions just in case you deleted too much.
