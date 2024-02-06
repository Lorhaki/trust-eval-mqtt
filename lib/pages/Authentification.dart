import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
        title: Text("Page de connexion") ,
      ),
      body:  Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Form(
            child: Column(
              children: [
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(hintText: "Email"),
                ),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(hintText: "Password"),
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
                  onPressed: () {
                    final auth = FirebaseAuth.instance;
                    auth.createUserWithEmailAndPassword(
                        email: emailController.text,
                        password: passwordController.text
                    );

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
      auth.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);

  }
}
