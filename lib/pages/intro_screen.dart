import 'dart:async';
import 'package:flutter/material.dart';
import 'home_screen.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  @override
  Widget build(BuildContext context) {
    Timer(
      const Duration(seconds: 5),
      () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
        );
      },
    );

    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.jpg'),
                opacity: 0.5,
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Visual Animal Detector",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(),
                  child: BackdropFilter(
                    filter: const ColorFilter.mode(
                        Colors.white30, BlendMode.overlay),
                    blendMode: BlendMode.modulate,
                    child: Image.asset(
                      "assets/animal.jpg",
                      width: double.infinity,
                      fit: BoxFit.cover,
                      height: 300,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
