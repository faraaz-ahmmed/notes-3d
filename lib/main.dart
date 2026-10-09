import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'viewmodels/notes_viewmodel.dart';
import 'views/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Start Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // End Firebase

  runApp(const NotesApp());
}

class NotesApp extends StatelessWidget {
  const NotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Start Provider
    return ChangeNotifierProvider(
      create: (_) => NotesViewModel(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Notes 3D',
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xffeef2ff),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xff6c4df6),
          ),
        ),
       home: const SplashScreen(),
      ),
    );
    // End Provider
  }
}
