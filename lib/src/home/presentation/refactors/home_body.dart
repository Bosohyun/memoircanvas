import 'package:flutter/material.dart';
import 'package:memoircanvas/core/extensions/context_extension.dart';
import 'package:memoircanvas/core/res/colors.dart';
import 'package:memoircanvas/core/res/fonts.dart';
import 'package:memoircanvas/src/journal/presentation/views/journal_view.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              horizontal: 50,
              vertical: 17,
            ),
            backgroundColor: Colours.primaryColour,
            foregroundColor: Colors.white,
          ),
          onPressed: () {
            context.push(const JournalView());
          },
          child: const Text(
            'Write a Journal',
            style: TextStyle(
              fontFamily: Fonts.aeonik,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );
  }
}
