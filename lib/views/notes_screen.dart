import 'package:flutter/material.dart';

class NotesScreen extends StatelessWidget {
  const NotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Start Body
    return const Scaffold(
      body: Center(
        child: Text(
          'My Notes',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Color(0xff29255e),
          ),
        ),
      ),
    );
    // End Body
  }
}