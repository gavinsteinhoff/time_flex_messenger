import 'package:flutter/material.dart';
import 'package:time_flex_messenger/utils/authentication.dart';
import 'package:time_flex_messenger/screens/user_info_screen.dart';

class AnonymousSignInButton extends StatefulWidget {
  const AnonymousSignInButton({super.key});

  @override
  State<AnonymousSignInButton> createState() => _AnonymousSignInButtonState();
}

class _AnonymousSignInButtonState extends State<AnonymousSignInButton> {
  bool _isSigningIn = false;

  @override
  Widget build(BuildContext context) {
    return _isSigningIn
        ? const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          )
        : OutlinedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.white),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
              ),
            ),
            onPressed: () => buttonPressed(),
            child: const Padding(
              padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Continue as guest',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  buttonPressed() async {
    setState(() {
      _isSigningIn = true;
    });

    final user = await Authentication.signInAnonymous(context: context);

    setState(() {
      _isSigningIn = false;
    });

    if (user != null) {
      if (!context.mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => UserInfoScreen(
            user: user,
          ),
        ),
      );
    }
  }
}
