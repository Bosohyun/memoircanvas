import 'package:flutter/material.dart';
import 'package:memoircanvas/core/common/widgets/gradient_background.dart';
import 'package:memoircanvas/core/extensions/context_extension.dart';
import 'package:memoircanvas/core/res/media_res.dart';
import 'package:memoircanvas/src/journal/domain/entities/journal.dart';

class JournalDetailsScreen extends StatelessWidget {
  const JournalDetailsScreen(this.journal, {super.key});

  static const routeName = '/journal-details';

  final Journal journal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        extendBodyBehindAppBar: true,
        appBar: AppBar(title: Text(journal.title)),
        body: GradientBackground(
          image: MediaRes.homeGradientBackground,
          child: SafeArea(
            child: ListView(padding: const EdgeInsets.all(20), children: [
              SizedBox(
                height: context.height * .3,
                child: Center(child: Image.network(journal.imageURL)),
              ),
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    journal.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    journal.diary,
                  )
                ],
              ),
            ]),
          ),
        ));
  }
}
