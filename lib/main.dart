// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lost_items/controller/repository/auth_repo.dart';
// import 'package:lost_items/firebase_options.dart';
import 'package:lost_items/pages/auth/email_page.dart';
import 'package:lost_items/pages/select_action.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
//  await AuthRepository.instance.init(); 
//   await Firebase.initializeApp(
//   options: DefaultFirebaseOptions.currentPlatform,
// );
  
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  static GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Bear Find',
        debugShowMaterialGrid: false,
        navigatorKey: navKey,
        debugShowCheckedModeBanner: false,
        // theme: ThemeData(
        //   scaffoldBackgroundColor: Colors.white,
        //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.black,primary: Colors.black),
        //   useMaterial3: true,
        // ),
        home:
         AuthRepository.instance.token.isEmpty
            ? 
            const EmailWidget()
            : const ActionSelector()
            );
  }
}
