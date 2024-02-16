import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyInsc extends StatefulWidget {
  const MyInsc({super.key});

  @override
  State<MyInsc> createState() => _MyAuthState();
}

class _MyAuthState extends State<MyInsc>{
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final pseudoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text("Page inscription") ,
      ),
      body:  Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            child: Column(
              children: [
                TextFormField(
                  controller: pseudoController,
                  decoration: const InputDecoration(hintText: "Pseudo"),
                ),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(hintText: "Email"),
                ),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(hintText: "Password"),
                ),

                ElevatedButton(
                  onPressed: () async {
                        //Implementer le systéme d'inscription avec Mosquitto ICI !!
                  },
                  child: const Text("Valider"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> login() async{
    final auth = FirebaseAuth.instance;
    // print(auth.currentUser!.uid + "azeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee");
    auth.signInWithEmailAndPassword(
        email: emailController.text, password: passwordController.text);
  }
}