import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Voici l'application TrustEval.",
              style: TextStyle(
                fontSize: 24,
              ),
            ),
            Text(
              "Une application permettant de creer des evenements et de les approuver",
              style: TextStyle(
                fontSize: 12,
              ),
            ),
          ],
        )
    );
  }
}