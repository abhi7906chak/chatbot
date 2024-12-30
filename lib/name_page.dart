import 'package:chatbot/home.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import "package:lottie/lottie.dart";

class NamePage extends StatefulWidget {
  const NamePage({super.key});

  @override
  State<NamePage> createState() => _NamePageState();
}

class _NamePageState extends State<NamePage> {
  final TextEditingController namecon = TextEditingController();

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
              Column(
                children: [
                  SizedBox(
                      height: 40,
                      width: 200,
                      child: TextField(
                        controller: namecon,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(19))),
                            hintText: "Type a Name"),
                      )),
                  ElevatedButton(
                      onPressed: () {
                        if (namecon.text.isEmpty) {
                          if (kDebugMode) {
                            print("Give a name");
                          }
                          Get.showSnackbar(const GetSnackBar(
                            title: "Oh ho !",
                            message: "Enter a name ",
                            duration: Duration(seconds: 3),
                          ));
                        } else {
                          if (kDebugMode) {
                            print(namecon);
                          }
                          Get.showSnackbar(const GetSnackBar(
                            title: "Great !",
                            message: "Lets Fun ",
                            duration: Duration(seconds: 3),
                          ));

                          Get.to(const HomePage(),
                              transition: Transition.leftToRight);
                        }
                      },
                      child: const Text("Done")),
                ],
              )
            ],
          )),
    );
  }
}
