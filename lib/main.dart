import 'package:blockchain_demo/blockchain_add_view_data/documents.dart';
import 'package:blockchain_demo/blockchain_add_view_data/viewdata.dart';
import 'package:blockchain_demo/login_signup/login.dart';
import 'package:blockchain_demo/login_signup/signup.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:blockchain_demo/blockchain_services/notes_service.dart';

import 'firebase_options.dart'; // Import your NotesServices class


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Run the app with MultiProvider
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NotesServices()),
        // Add more providers as needed
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Your App Title',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:  Login(),
    );
  }
}

// Define your other app components and routes here
