import 'package:flutter/material.dart';
import 'package:lost_items/pages/auth/email_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bear Find',
      debugShowMaterialGrid: false,
      debugShowCheckedModeBanner: false,
    
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
      ),
      home: const EmailWidget()
    );
  }
}
