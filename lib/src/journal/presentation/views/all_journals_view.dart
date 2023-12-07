import 'package:flutter/material.dart';
import 'package:memoircanvas/core/common/widgets/gradient_background.dart';
import 'package:memoircanvas/core/common/widgets/nested_back_button.dart';
import 'package:memoircanvas/core/res/media_res.dart';
import 'package:memoircanvas/src/journal/domain/entities/journal.dart';
import 'package:memoircanvas/src/journal/presentation/views/jouranl_details_screen.dart';
import 'package:memoircanvas/src/journal/presentation/widgets/journal_tile.dart';

class AllJournalsView extends StatelessWidget {
  const AllJournalsView(this.journals, {super.key});

  final List<Journal> journals;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: const NestedBackButton(),
      ),
      body: GradientBackground(
        image: MediaRes.homeGradientBackground,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  'All Journals',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 24,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: Wrap(
                  spacing: 20,
                  runSpacing: 40,
                  runAlignment: WrapAlignment.spaceEvenly,
                  children: journals
                      .map(
                        (journal) => JournalTile(
                            journal: journal,
                            onTap: () => {
                                  Navigator.of(context).pushNamed(
                                      JournalDetailsScreen.routeName,
                                      arguments: journal)
                                }),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
