import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

import 'package:memoircanvas/core/extensions/context_extension.dart';
import 'package:memoircanvas/core/utils/core_utils.dart';

import 'package:memoircanvas/src/settings/presentation/widgets/setting_tile.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  sendEmail() async {
    final Email email = Email(
      body: '',
      subject: '',
      recipients: ['kbh900220@gmail.com'],
      cc: [],
      bcc: [],
      attachmentPaths: [],
      isHTML: false,
    );

    try {
      await FlutterEmailSender.send(email);
    } catch (error) {
      String title = 'Unable to send email';

      String message =
          "Unable to use the default mail app, making it difficult to send inquiries directly through the app.\n\nPlease contact the following email for assistance, and a response will be provided kindly:)\n\nkbh900220@gmail.com";

      if (mounted) {
        CoreUtils.showCustomDialog(context,
            height: 300,
            title: title,
            content: message,
            buttonHighlightColor: context.theme.colorScheme.primary,
            buttonTextColor: Colors.white,
            isCancelBtn: false,
            actionText: 'Ok', action: () {
          Navigator.pop(context);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.colorScheme.primary.withOpacity(0.05),
      appBar: AppBar(
        title: Text(
          'Settings',
          style: context.theme.textTheme.displayLarge,
        ),
      ),
      body: ListView(
        children: [
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              const SizedBox(
                width: 20,
              ),
              Text(
                'Premium',
                style: context.theme.textTheme.displaySmall?.copyWith(
                    color: context.theme.colorScheme.primary, fontSize: 17),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          SettingTile(
              leadingIcon: Icon(Icons.account_circle,
                  color: context.theme.colorScheme.primary),
              title: 'Subscribe to Premium',
              onTap: () {}),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              const SizedBox(
                width: 20,
              ),
              Text(
                'Account',
                style: context.theme.textTheme.displaySmall?.copyWith(
                    color: context.theme.colorScheme.primary, fontSize: 17),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          SettingTile(
            leadingIcon: Icon(Icons.info_outline_rounded,
                color: context.theme.colorScheme.primary),
            title: 'Account Info',
            trailingIcon: null,
            onTap: () {
              CoreUtils.showCustomDialog(context,
                  height: 177,
                  title: 'Account Info',
                  content:
                      'Email: ${FirebaseAuth.instance.currentUser?.email}\n'
                      'Name: ${FirebaseAuth.instance.currentUser?.displayName}',
                  buttonHighlightColor: context.theme.colorScheme.primary,
                  buttonTextColor: Colors.white,
                  isCancelBtn: false,
                  actionText: 'Ok', action: () {
                Navigator.pop(context);
              });
            },
          ),
          SettingTile(
            leadingIcon: const Icon(
              Icons.logout,
            ),
            title: 'Logout',
            onTap: () async {
              CoreUtils.showCustomDialog(context,
                  height: 160,
                  title: 'Logout',
                  content: 'Are you sure you want to logout?',
                  buttonHighlightColor: context.theme.colorScheme.error,
                  buttonTextColor: Colors.white,
                  actionText: 'Logout', action: () async {
                final navigator = Navigator.of(context);

                await FirebaseAuth.instance.signOut();

                unawaited(
                  navigator.pushNamedAndRemoveUntil(
                    '/',
                    (route) => false,
                  ),
                );
              });
            },
            trailingIcon: null,
          ),
          SettingTile(
            leadingIcon: Icon(
              Icons.delete_rounded,
              color: context.theme.colorScheme.error,
            ),
            title: 'Delete Account',
            color: context.theme.colorScheme.error,
            onTap: () {
              CoreUtils.showCustomDialog(context,
                  height: 180,
                  title: 'Delete Account',
                  content: 'Are you sure you want to delete your account?',
                  buttonHighlightColor: context.theme.colorScheme.error,
                  buttonTextColor: Colors.white,
                  actionText: 'Delete', action: () async {
                final navigator = Navigator.of(context);

                await FirebaseAuth.instance.currentUser?.delete();

                unawaited(
                  navigator.pushNamedAndRemoveUntil(
                    '/',
                    (route) => false,
                  ),
                );
              });
            },
            trailingIcon: null,
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              const SizedBox(
                width: 20,
              ),
              Text(
                'Contact',
                style: context.theme.textTheme.displaySmall?.copyWith(
                    color: context.theme.colorScheme.primary, fontSize: 17),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          SettingTile(
              leadingIcon: const Icon(Icons.account_circle),
              title: 'Send Feedback',
              onTap: () async {
                sendEmail();
              }),
        ],
      ),
    );
  }
}
