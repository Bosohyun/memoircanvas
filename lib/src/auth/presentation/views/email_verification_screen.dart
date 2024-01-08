import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memoircanvas/core/extensions/context_extension.dart';
import 'package:memoircanvas/core/utils/core_utils.dart';
import 'package:memoircanvas/src/auth/presentation/bloc/auth_bloc.dart';
import 'package:memoircanvas/src/auth/presentation/views/sign_in_screen.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  bool isEmailVerified = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    timer =
        Timer.periodic(const Duration(seconds: 3), (_) => checkEmailVerified());
  }

  checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser?.reload();
    if (mounted) {
      setState(() {
        isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
      });
    }

    if (isEmailVerified) {
      if (isEmailVerified) {
        timer?.cancel();

        // snackbar to show email verified

        if (mounted) {
          CoreUtils.showSnackBar(context, 'Email Verified');
        }

        //naviage to sign in screen
        if (mounted) {
          Navigator.of(context).pushReplacementNamed(SignInScreen.routeName);
        }
      }
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //listen firebase auth email verification

    return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      return Scaffold(
        backgroundColor: context.theme.colorScheme.background,
        appBar: AppBar(
          title: const Text('Email Verification'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Verify your email to continue',
                style: TextStyle(
                  fontSize: 20,
                  color: context.theme.colorScheme.onPrimary,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: context.theme.colorScheme.primary,
                    foregroundColor: Colors.white),
                onPressed: () {
                  //Navagate to sign in screen
                  Navigator.of(context)
                      .pushReplacementNamed(SignInScreen.routeName);
                },
                child: const Text('Back to Sign In'),
              ),
            ],
          ),
        ),
      );
    });
  }
}
