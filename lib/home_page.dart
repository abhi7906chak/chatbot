import 'package:flutter/material.dart';
import "package:lottie/lottie.dart";

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          body: ListView(
            children: [
              LottieBuilder.asset(
                "assets/ani2.json",
              ),
              Row(
                children: [
                  ElevatedButton(
                      onPressed: () {}, child: const Text("continue in chat"))
                ],
              )
            ],
          )),
    );
  }
}
