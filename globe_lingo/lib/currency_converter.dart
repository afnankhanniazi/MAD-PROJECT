import 'package:flutter/material.dart';
import 'history_helper.dart';

class CurrencyScreen extends StatefulWidget {
  const CurrencyScreen({super.key});

  @override
  State<CurrencyScreen> createState() => _CurrencyScreenState();
}

class _CurrencyScreenState extends State<CurrencyScreen> {
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
    double conversion = (inputAmount / fromRate) * toRate;
    
    setState(() {
      result = conversion.toStringAsFixed(2);
    });
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
      appBar: AppBar(
        title: const Text('Currency Converter'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              HistoryHelper.addToHistory(
                "Currency Conversion", 
                "$amount $fromCurrency = $result $toCurrency"
              );
              
              // Show a little "Saved" popup
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Conversion saved to History!")),
              );
            },
          ),
        ],
      ),
      // ... rest of the body code ...
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      TextField(
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(
                          labelText: 'Amount to Convert',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.monetization_on),
                        ),
                        onChanged: (value) {
                          amount = value;
                          convertCurrency();
                        },
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              initialValue: fromCurrency,
                              decoration: const InputDecoration(labelText: 'From', border: OutlineInputBorder()),
                              items: exchangeRates.keys.map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
                              onChanged: (v) { setState(() { fromCurrency = v!; convertCurrency(); }); },
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Icon(Icons.swap_horiz, size: 30, color: Colors.indigo),
                          const SizedBox(width: 10),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              initialValue: toCurrency,
                              decoration: const InputDecoration(labelText: 'To', border: OutlineInputBorder()),
                              items: exchangeRates.keys.map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
                              onChanged: (v) { setState(() { toCurrency = v!; convertCurrency(); }); },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      const Text("Result:", style: TextStyle(color: Colors.grey)),
                      Text(
                        result,
                        style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.indigo),
                      ),
                      Text(toCurrency, style: const TextStyle(fontSize: 18, color: Colors.indigo)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}