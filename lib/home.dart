import 'dart:developer' as developer;

import 'package:chatbot/secret.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:lottie/lottie.dart';
import 'package:speech_to_text/speech_to_text.dart';

// Replace with your actual API key. Store this securely in a real app!
const apiKey = 'YOUR_API_KEY';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final SpeechToText sptext = SpeechToText();
  FlutterTts flutterTts = FlutterTts();
  bool speechEnable = false;
  String WordSpoken = "";
  double confidence = 0;
  dynamic model;
  bool _isLoading = false;
  bool _isSpeaking = false;
  int _requestCount = 0;

  @override
  void initState() {
    super.initState();
    call();
    speak();
    _initializeModel();
  }

  Future<void> speak() async {
    await flutterTts.setSharedInstance(true);
    setState(() {});
  }

  Future<void> speech(String words) async {
    await flutterTts.speak(words);
  }

  Future<void> call() async {
    speechEnable = await sptext.initialize();
    setState(() {});
  }

  Future<void> _initializeModel() async {
    try {
      model =
          GenerativeModel(model: 'gemini-1.5-flash-latest', apiKey: BARDAPI);
    } catch (e) {
      developer.log("Error initializing model: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error initializing model: $e')),
      );
    }
  }

  void startListening() async {
    await sptext.listen(onResult: onResult).then((value) {
      if (kDebugMode) {
        developer.log("Start listening");
      }
    });

    setState(() {
      confidence = 0;
    });
  }

  void onResult(result) {
    setState(() {
      WordSpoken = "${result.recognizedWords}";
      confidence = result.confidence;
    });
  }

  void stopListening() async {
    await sptext.stop().then((value) {
      if (kDebugMode) {
        developer.log("Stopped listening");
      }
    });

    setState(() {});
  }

  Future<void> _generateText(String prompt) async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      WordSpoken = "Generating response...";
      _isSpeaking = false;
    });

    try {
      if (prompt.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please speak something.')),
        );
        return;
      }

      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);

      setState(() {
        WordSpoken = response.text ?? 'No response';
        _requestCount++;
        developer.log('Request Count: $_requestCount');
        if (WordSpoken.isNotEmpty) {
          speech(WordSpoken);
          _isSpeaking = true;
        }
      });

      if (_requestCount >= 10) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'You\'ve made a number of requests. Please be mindful of potential costs.'),
          ),
        );
      }
    } catch (e) {
      setState(() {
        WordSpoken = 'Error: $e';
      });
      developer.log('Error generating text: $e');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('An error occurred: $e')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            children: [
              LottieBuilder.asset("assets/ani.json"),
              Container(
                padding: const EdgeInsets.all(16),
                child: Text(
                  sptext.isListening
                      ? "Listening..."
                      : speechEnable
                          ? "Tap to Talk to Start"
                          : "Give Mic Permission",
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: _isLoading
                        ? const Center(
                            child: CircularProgressIndicator(),
                          ) // Loading indicator
                        : Text(
                            WordSpoken,
                            style: const TextStyle(
                                fontSize: 25, fontWeight: FontWeight.w300),
                          ),
                  ),
                ),
              ),
              if (_isSpeaking)
                ElevatedButton(
                  onPressed: () async {
                    await flutterTts.stop();
                    setState(() {
                      _isSpeaking = false;
                    });
                  },
                  child: const Text("Stop"),
                ),
              if (sptext.isNotListening && confidence > 0)
                Padding(
                  padding: const EdgeInsets.only(bottom: 100),
                  child: Text(
                    "Confidence: ${(confidence * 100).toStringAsFixed(1)}%",
                    style: const TextStyle(
                        fontSize: 30, fontWeight: FontWeight.w200),
                  ),
                ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            if (sptext.isListening) {
              stopListening();

              if (WordSpoken.isNotEmpty) {
                _generateText(WordSpoken); // Call Gemini API here
                // String result = await ApiServices().post(WordSpoken);
                // developer.log(result);
              }
              setState(() {});
            } else {
              startListening();
            }
          },
          tooltip: "Toggle Listening",
          child: Icon(sptext.isNotListening ? Icons.mic_off : Icons.mic),
        ),
      ),
    );
  }
}
