import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:memoircanvas/core/common/widgets/rounded_button.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: RoundedButton(
          label: 'Log out',
          onPressed: () async {
            final navigator = Navigator.of(context);
            await FirebaseAuth.instance.signOut();
            unawaited(
              navigator.pushNamedAndRemoveUntil(
                '/',
                (route) => false,
              ),
            );
          },
        ),
      ),
    );
  }
}
