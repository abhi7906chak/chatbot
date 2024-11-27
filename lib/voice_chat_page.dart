import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class VoiceChatPage extends StatefulWidget {
  const VoiceChatPage({super.key});

  @override
  State<VoiceChatPage> createState() => _VoiceChatPageState();
}

class _VoiceChatPageState extends State<VoiceChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Lottie.asset('assets/ani.json'),
          const Text("Choco"),
        ],
      ),
    );
  }
}
