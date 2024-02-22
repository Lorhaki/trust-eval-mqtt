import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trust_eval/pages/Authentification.dart';
import 'objets/Utilisateur.dart';
import 'pages/MenuDefillant.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Utilisateur userActu = Utilisateur(50, "", "", 0, 0, "");
int idUser = 0;
String ipServeur = '172.24.16.1';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  int _currentIndex = 0;

  setCurrentIndex(int index){
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, AsyncSnapshot<User?> snapshot) {
          if(snapshot.hasData && snapshot.data != null){
              return const MyMenu();
          }else if (snapshot.connectionState == ConnectionState.waiting){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return const MyAuth();
        }

      ),
    );
  }
}