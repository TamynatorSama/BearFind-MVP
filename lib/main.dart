import 'package:flutter/material.dart';
import 'package:lost_items/controller/repository/auth_repo.dart';
import 'package:lost_items/pages/auth/email_page.dart';
import 'package:lost_items/pages/select_action.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthRepository.instance.init();
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
        home: 
        AuthRepository.instance.token.isEmpty?
         const EmailWidget()
        :const ActionSelector()
        );
  }
}
