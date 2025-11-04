import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const SentimentApp());
}

class SentimentApp extends StatelessWidget {
  const SentimentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Amazon Sentiment Analyzer',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color.fromARGB(255, 181, 124, 63),
        brightness: Brightness.light,
      ),
      debugShowCheckedModeBanner: false,
      home: const SentimentHomePage(),
    );
  }
}

class SentimentHomePage extends StatefulWidget {
  const SentimentHomePage({super.key});

  @override
  State<SentimentHomePage> createState() => _SentimentHomePageState();
}

class _SentimentHomePageState extends State<SentimentHomePage> {
  final TextEditingController _controller = TextEditingController();
  String _result = "";
  bool _isLoading = false;

  final String apiUrl =
      "https://birolshn-amazon-sentiment-api.hf.space/api/predict";

  Future<void> analyzeSentiment(String text) async {
    if (text.trim().isEmpty) return;

    setState(() {
      _isLoading = true;
      _result = "";
    });

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "data": [text],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String label = data["data"][0][0]["label"];
        double score = data["data"][0][0]["score"];

        if (label == "positive") {
          label = "😊 Positive";
        } else {
          label = "☹️ negative";
        }

        setState(() {
          _result = "$label (${(score * 100).toStringAsFixed(1)}%)";
        });
      } else {
        setState(() {
          _result = "Error: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        _result = "Connection error.";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        title: const Text(
          "Amazon Sentiment Analyzer",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: colors.primaryContainer,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: SingleChildScrollView(
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              shadowColor: colors.primary.withOpacity(0.2),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      "Enter a review below:",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: "e.g. This product is amazing!",
                        filled: true,
                        fillColor: colors.surfaceVariant.withOpacity(0.5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: colors.primary,
                            width: 1.8,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      minLines: 3,
                      maxLines: 5,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed:
                          _isLoading
                              ? null
                              : () => analyzeSentiment(_controller.text),
                      icon: const Icon(Icons.auto_awesome),
                      label: Text(
                        _isLoading ? "Analyzing..." : "Analyze Sentiment",
                        style: const TextStyle(fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        backgroundColor: colors.primary,
                        foregroundColor: colors.onPrimary,
                      ),
                    ),
                    const SizedBox(height: 30),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      child:
                          _isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : _result.isEmpty
                              ? const SizedBox.shrink()
                              : Container(
                                key: ValueKey(_result),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: colors.secondaryContainer,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  _result,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: colors.onSecondaryContainer,
                                  ),
                                ),
                              ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
