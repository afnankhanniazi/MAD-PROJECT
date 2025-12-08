import 'package:flutter/material.dart';
import 'dart:async';

void main() {
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

    // Navigate to Login Screen after 3 seconds
    Future.delayed(const Duration(seconds: 7), () {
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

// --- LOGIN SCREEN ---
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLogin = true;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void handleAuth() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
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
                onPressed: handleAuth,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  isLogin ? 'Login' : 'Sign Up',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
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
// --- HOME PAGE WITH SIDEBAR & TRANSLATOR UI ---
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final inputController = TextEditingController();
  String translatedText = "";
  String selectedLanguage = 'es';
  bool isLoading = false;

  // List of languages for the dropdown
  final languageMap = {
    'Spanish': 'es',
    'French': 'fr',
    'German': 'de',
    'Urdu': 'ur',
    'Chinese': 'zh-cn',
  };

  // Mock translation function for UI demonstration
  Future<void> translateText() async {
    if (inputController.text.isEmpty) return;
    
    setState(() => isLoading = true);
    
    // Fake delay to simulate translation
    await Future.delayed(const Duration(seconds: 1));
    
    setState(() {
      translatedText = "Translated: ${inputController.text} (Simulation)";
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GlobeLingo Translator'),
      ),
      // The Sidebar Menu (Drawer)
      drawer: Drawer(
        child: ListView(
          children: [
             DrawerHeader(
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              child: const Text(
                'GlobeLingo Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.translate),
              title: const Text('Translator'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Translation History'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HistoryScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.access_time),
              title: const Text('Time & Currency'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TimeAndCurrencyScreen()),
                );
              },
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
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Input Text Field
            TextField(
              controller: inputController,
              decoration: const InputDecoration(
                labelText: 'Enter text to translate',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            
            // Language Dropdown & Button Row
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: selectedLanguage,
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
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => selectedLanguage = value);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 20),
                ElevatedButton.icon(
                  onPressed: isLoading ? null : translateText,
                  icon: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Icon(Icons.translate),
                  label: Text(isLoading ? 'Translating...' : 'Translate'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            
            // Output Area
            if (translatedText.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Translation:',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    Text(translatedText, style: const TextStyle(fontSize: 18)),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// --- PLACEHOLDERS FOR OTHER SCREENS ---
class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Translation History')),
      body: const Center(child: Text("History UI Coming Soon")),
    );
  }
}
// --- TIME & CURRENCY SCREEN ---
class TimeAndCurrencyScreen extends StatefulWidget {
  const TimeAndCurrencyScreen({super.key});

  @override
  State<TimeAndCurrencyScreen> createState() => _TimeAndCurrencyScreenState();
}

class _TimeAndCurrencyScreenState extends State<TimeAndCurrencyScreen> {
  // Static data to simulate World Time without extra packages
  final List<Map<String, String>> worldTimes = [
    {'city': 'New York', 'time': '13:39 PM'},
    {'city': 'London', 'time': '18:39 PM'},
    {'city': 'Tokyo', 'time': '02:39 AM'},
    {'city': 'Sydney', 'time': '03:39 AM'},
    {'city': 'Dubai', 'time': '21:39 PM'},
    {'city': 'Paris', 'time': '19:39 PM'},
  ];

  // Currency Converter Variables
  final Map<String, double> exchangeRates = {
    'USD': 1.0,
    'EUR': 0.92,
    'GBP': 0.79,
    'PKR': 279.50,
    'INR': 83.12,
  };

  String fromCurrency = 'USD';
  String toCurrency = 'EUR';
  String amount = "1";
  String result = "0.92";

  void convertCurrency() {
    double inputAmount = double.tryParse(amount) ?? 0.0;
    double fromRate = exchangeRates[fromCurrency]!;
    double toRate = exchangeRates[toCurrency]!;
    
    // Logic: Convert to USD first, then to target currency
    double conversion = (inputAmount / fromRate) * toRate;
    
    setState(() {
      result = conversion.toStringAsFixed(2);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Time & Currency')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- WORLD TIME SECTION ---
            const Text(
              'World Time',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 4,
              child: ListView.builder(
                shrinkWrap: true, // Important for nested lists
                physics: const NeverScrollableScrollPhysics(),
                itemCount: worldTimes.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Icons.access_time, color: Colors.indigo),
                    title: Text(worldTimes[index]['city']!),
                    subtitle: Text("Today, ${worldTimes[index]['time']}"),
                  );
                },
              ),
            ),
            
            const SizedBox(height: 32),

            // --- CURRENCY CONVERTER SECTION ---
            const Text(
              'Currency Converter',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Amount Input
                    TextField(
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Amount',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        amount = value;
                        convertCurrency();
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    // Dropdowns Row
                    Row(
                      children: [
                        // FROM Currency
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            initialValue: fromCurrency,
                            decoration: const InputDecoration(
                              labelText: 'From',
                              border: OutlineInputBorder(),
                            ),
                            items: exchangeRates.keys.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                fromCurrency = newValue!;
                                convertCurrency();
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Icon(Icons.arrow_forward),
                        const SizedBox(width: 16),
                        // TO Currency
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            initialValue: toCurrency,
                            decoration: const InputDecoration(
                              labelText: 'To',
                              border: OutlineInputBorder(),
                            ),
                            items: exchangeRates.keys.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                toCurrency = newValue!;
                                convertCurrency();
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    
                    // Result Display
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.indigo.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Text(
                            result,
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.indigo,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "$amount $fromCurrency = $result $toCurrency",
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
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