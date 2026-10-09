import 'dart:async';

import 'package:flutter/material.dart';

import 'notes_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? timer;

  @override
  void initState() {
    super.initState();

    // Start Timer
    timer = Timer(const Duration(seconds: 2), () {
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const NotesScreen(),
        ),
      );
    });
    // End Timer
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Start Body
    return Scaffold(
      backgroundColor: const Color(0xffeef2ff),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Start App Icon
              Container(
                width: 135,
                height: 135,
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: const Color(0xffeef2ff),
                  borderRadius: BorderRadius.circular(35),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.white,
                      offset: Offset(-8, -8),
                      blurRadius: 16,
                    ),
                    BoxShadow(
                      color: Color(0x405c6692),
                      offset: Offset(8, 8),
                      blurRadius: 16,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(27),
                  child: Image.asset(
                    'assets/icons/app_icon.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // End App Icon

              const SizedBox(height: 28),

              const Text(
                'Notes 3D',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff29255e),
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Save your ideas',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),

              const SizedBox(height: 30),

              const CircularProgressIndicator(
                color: Color(0xff6c4df6),
              ),
            ],
          ),
        ),
      ),
    );
    // End Body
  }
}