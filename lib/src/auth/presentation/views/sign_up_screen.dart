import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:memoircanvas/core/common/app/providers/user_provider.dart';
import 'package:memoircanvas/core/common/widgets/rounded_button.dart';
import 'package:memoircanvas/core/extensions/context_extension.dart';
import 'package:memoircanvas/core/res/media_res.dart';
import 'package:memoircanvas/core/utils/core_utils.dart';
import 'package:memoircanvas/src/auth/data/models/user_model.dart';
import 'package:memoircanvas/src/auth/presentation/bloc/auth_bloc.dart';
import 'package:memoircanvas/src/auth/presentation/views/email_verification_screen.dart';
import 'package:memoircanvas/src/auth/presentation/views/sign_in_screen.dart';
import 'package:memoircanvas/src/auth/presentation/widgets/sign_up_form.dart';
import 'package:memoircanvas/src/dashboard/presentation/views/dashboard.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  static const routeName = '/sign-up';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final emailController = TextEditingController();
  final fullNameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    fullNameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.colorScheme.background,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (_, state) async {
          if (state is AuthError) {
            CoreUtils.showSnackBar(context, state.message);
          } else if (state is EmailVerificationSent) {
            await Future.delayed(const Duration(milliseconds: 500));

            if (mounted) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: context.read<AuthBloc>(),
                    child: const EmailVerificationScreen(),
                  ),
                ),
              );
            }
            // if (mounted) {
            //   context.read<AuthBloc>().add(SignInEvent(
            //         email: emailController.text.trim(),
            //         password: passwordController.text.trim(),
            //       ));
            // }
          } else if (state is SignedIn) {
            context.read<UserProvider>().initUser(state.user as LocalUserModel);
            Navigator.pushReplacementNamed(context, Dashboard.routeName);
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: context.theme.colorScheme.background,
            body: SafeArea(
              child: Center(
                child: ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    SizedBox(
                      height: context.height * 0.25,
                      child: Image.asset(MediaRes.signUpIconImage),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                            context,
                            SignInScreen.routeName,
                          );
                        },
                        child: const Text(
                          'Already have an account?',
                        ),
                      ),
                    ),
                    SignUpForm(
                      emailController: emailController,
                      fullNameController: fullNameController,
                      passwordController: passwordController,
                      confirmPasswordController: confirmPasswordController,
                      formKey: formKey,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    if (state is AuthLoading)
                      const Center(
                        child: CircularProgressIndicator(),
                      )
                    else if (state is SignedUp)
                      const Center(
                        child: Icon(
                          Icons.done,
                          color: Colors.green,
                          size: 40,
                        ),
                      )
                    else
                      RoundedButton(
                        label: 'Sign Up',
                        onPressed: () {
                          FocusManager.instance.primaryFocus?.unfocus();
                          FirebaseAuth.instance.currentUser?.reload();
                          if (formKey.currentState!.validate()) {
                            context.read<AuthBloc>().add(SignUpEvent(
                                  email: emailController.text.trim(),
                                  password: passwordController.text.trim(),
                                  fullName: fullNameController.text.trim(),
                                ));
                          }
                        },
                      )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
