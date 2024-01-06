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
import 'package:memoircanvas/src/auth/presentation/views/sign_up_screen.dart';
import 'package:memoircanvas/src/auth/presentation/widgets/sign_in_form.dart';
import 'package:memoircanvas/src/dashboard/presentation/views/dashboard.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  static const routeName = '/sign-in';

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: BlocConsumer<AuthBloc, AuthState>(
          listener: (_, state) async {
            if (state is AuthError) {
              CoreUtils.showSnackBar(context, state.message);
            } else if (state is SignedIn) {
              await Future.delayed(const Duration(milliseconds: 500));
              if (mounted) {
                context
                    .read<UserProvider>()
                    .initUser(state.user as LocalUserModel);
                Navigator.pushReplacementNamed(context, Dashboard.routeName);
              }
            }
          },
          builder: (context, state) {
            return Scaffold(
              backgroundColor: context.theme.colorScheme.background,
              body: SafeArea(
                child: Center(
                  child: ListView(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    children: [
                      SizedBox(
                        height: context.height * 0.25,
                        child: Image.asset(MediaRes.signInIconImage),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Baseline(
                            baseline: 50,
                            baselineType: TextBaseline.alphabetic,
                            child: TextButton(
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                    context, SignUpScreen.routeName);
                              },
                              child: const Text(
                                'Register account?',
                              ),
                            ),
                          )
                        ],
                      ),
                      SignInForm(
                          emailController: emailController,
                          passwordController: passwordController,
                          formKey: formKey),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/forgot-password');
                          },
                          child: const Text('Forgot Password?'),
                        ),
                      ),
                      if (state is AuthLoading)
                        const Center(child: CircularProgressIndicator())
                      else if (state is SignedIn)
                        const Center(
                          child: Icon(
                            Icons.done,
                            color: Colors.green,
                            size: 40,
                          ),
                        )
                      else
                        RoundedButton(
                          label: 'Sign In',
                          onPressed: () {
                            FocusManager.instance.primaryFocus?.unfocus();
                            FirebaseAuth.instance.currentUser?.reload();
                            if (formKey.currentState!.validate()) {
                              context.read<AuthBloc>().add(
                                    SignInEvent(
                                      email: emailController.text.trim(),
                                      password: passwordController.text.trim(),
                                    ),
                                  );
                            }
                          },
                        ),
                      SizedBox(height: context.height * 0.02),
                      Text(
                        'Or',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: context.theme.colorScheme.primary,
                        ),
                      ),
                      SizedBox(height: context.height * 0.02),
                      GestureDetector(
                        onTap: () {
                          context.read<AuthBloc>().add(
                                SignInWithGoogleEvent(),
                              );
                        },
                        child: SizedBox(
                          width: 40,
                          height: 40,
                          child: Image.asset('assets/icons/google.png'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ));
  }
}
// Widget buildThirdPartyLogin(BuildContext context) {
//   return Container(
//     margin: EdgeInsets.only(top: 40.h, bottom: 20.h),
//     padding: EdgeInsets.only(left: 50.w, right: 50.w),
//     child: Row(
//       mainAxisAlignment: MainAxisAlignment.spaceAround,
//       children: [
//         _reusableIcons("google"),
//         _reusableIcons("apple"),
//         _reusableIcons("facebook")
//       ],
//     ),
//   );
// }

// Widget _reusableIcons(String iconName) {
//   return GestureDetector(
//     onTap: () {},
//     child: SizedBox(
//       width: 40.w,
//       height: 40.w,
//       child: Image.asset('assets/icons/$iconName.png'),
//     ),
//   );
// }