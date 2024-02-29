import 'package:flutter/material.dart';
import 'package:p2pbookshare/pages/login/widgets/signin_button.dart';
//FIXME: Cancelling google-sign-in abruptly stops app. handle sign-in cancelled case

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Scaffold(
        body: Padding(
          padding: const EdgeInsets.fromLTRB(25, 25, 25, 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Placeholder(),
              const SizedBox(height: 10.0),
              Text(
                "P2P BookShare:\nShare, Borrow, Learn - Your Campus Book Exchange",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 20.0),
              Text(
                "Unlock Affordable Learning, Foster Community, and Share Knowledge!",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 20.0),
              Text(
                "Dive into P2P BookShare: affordable learning, convenience, and collaborative sharing with fellow students. Unite textbooks and community spirit by signing in now! Let's make education budget-friendly and connected.",
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 40.0),
              Center(
                child: GSignInButton(
                  height: constraints.maxHeight * 0.08,
                  width: constraints.maxWidth * 0.8,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.09)
            ],
          ),
        ),
      ),
    );
  }
}
