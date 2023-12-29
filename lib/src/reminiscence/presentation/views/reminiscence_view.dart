import 'package:flutter/material.dart';
import 'package:memoircanvas/core/extensions/context_extension.dart';
import 'package:memoircanvas/src/reminiscence/presentation/refactors/reminiscence_body.dart';

class ReminiscenceView extends StatelessWidget {
  const ReminiscenceView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: context.theme.colorScheme.background,
        appBar: AppBar(
          title: Text(
            'Reminiscence',
            style: context.theme.textTheme.displayLarge,
          ),
        ),
        body: const SafeArea(child: ReminiscenceBody()));
  }
}
