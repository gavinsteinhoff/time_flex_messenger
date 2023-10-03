import 'package:flutter/material.dart';
import 'package:time_flex_messenger/utils/authentication.dart';
import 'package:time_flex_messenger/res/custom_colors.dart';
import 'package:time_flex_messenger/widgets/anonymous_sign_in_button.dart';
import 'package:time_flex_messenger/widgets/google_sign_in_button.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.firebaseNavy,
      body: SafeArea(
        child: Column(
          children: [
            const Text(
              'Time Flex Messenger',
              style: TextStyle(
                fontSize: 40,
              ),
            ),
            FutureBuilder(
              future: Authentication.initializeFirebase(context: context),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text('Error initializing Firebase');
                } else if (snapshot.connectionState == ConnectionState.done) {
                  return const Column(
                    children: [GoogleSignInButton(), AnonymousSignInButton()],
                  );
                }
                return const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    CustomColors.firebaseOrange,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
