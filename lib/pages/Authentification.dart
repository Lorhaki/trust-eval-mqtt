import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'Inscription.dart';

class MyAuth extends StatefulWidget {
  const MyAuth({super.key});

  @override
  State<MyAuth> createState() => _MyAuthState();
}

class _MyAuthState extends State<MyAuth>{
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text("Page de connexion") ,
      ),
      body:  Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            child: Column(
              children: [
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
                      if(emailController.text.isNotEmpty && passwordController.text.isNotEmpty && passwordController.text.length > 6){
                        login();
                      }
                    },
                    child: const Text("Connexion"),
                ),

                ElevatedButton(
                  onPressed: () async {
                    Navigator.push(
                    context, MaterialPageRoute(
                    builder: (context)=> MyInsc()
                    ),
                    /*final auth = FirebaseAuth.instance;
                    auth.createUserWithEmailAndPassword(
                        email: emailController.text,
                        password: passwordController.text
                    );
                      await Future.delayed(const Duration(seconds: 2));
                      CollectionReference user =  FirebaseFirestore.instance.collection("Users");
                      user.add({
                        "mail" : emailController.text,
                        "uid" : FirebaseAuth.instance.currentUser!.uid.characters.string,
                        "confiance" : 50
                      */);
                    },
                  child: const Text("Inscription"),
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
