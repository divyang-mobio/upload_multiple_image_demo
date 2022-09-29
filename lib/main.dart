import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'show_image_screen.dart';
import 'home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          appBarTheme: const AppBarTheme(
              centerTitle: true,
              titleTextStyle: TextStyle(color: Colors.white),
              iconTheme: IconThemeData(color: Colors.white)),
        ),
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/':
              return MaterialPageRoute(
                  builder: (context) => const MyHomePage());
            case '/showImage':
              return MaterialPageRoute(
                  builder: (context) => const ShowImagePage());
            default:
              return MaterialPageRoute(
                  builder: (context) => const MyHomePage());
          }
        },
        initialRoute: '/');
  }
}
