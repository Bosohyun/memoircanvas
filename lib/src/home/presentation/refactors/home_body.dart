import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:memoircanvas/core/extensions/context_extension.dart';
import 'package:memoircanvas/core/res/media_res.dart';
import 'package:memoircanvas/src/journal/domain/entities/journal.dart';
import 'package:memoircanvas/src/journal/presentation/cubit/journal_cubit.dart';
import 'package:memoircanvas/src/journal/presentation/views/add_gen_journal_view.dart';
import 'package:memoircanvas/src/journal/presentation/views/add_pick_journal_view.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

// int _consecutiveDays(List<Journal> journals) {
//   if (journals.isEmpty) return 0;

//   int consecutiveDays = 1;

//   DateTime lastDate = journals.first.createdAt;

//   for (int i = 1; i < journals.length; i++) {
//     final journal = journals[i];

//     if (journal.createdAt.difference(lastDate).inDays == 1) {
//       consecutiveDays++;
//     } else {
//       break;
//     }

//     lastDate = journal.createdAt;
//   }

//   return consecutiveDays;
// }

int _consecutiveDays(List<Journal> journals) {
  int consecutiveDays = 0; // Start from 0, assuming no entries yet
  DateTime today = DateTime.now();
  DateTime lastDate = DateTime(
      today.year, today.month, today.day); // Today's date with time stripped

  // Iterate through the remaining entries to find consecutive days
  for (var i = 0; i < journals.length; i++) {
    DateTime currentDate = DateTime(journals[i].createdAt.year,
        journals[i].createdAt.month, journals[i].createdAt.day);

    // Check if the current entry is exactly one day before the last date
    if (lastDate.difference(currentDate).inDays <= 1) {
      consecutiveDays++;
      lastDate = currentDate; // Move the marker back one day
    } else if (lastDate.difference(currentDate).inDays > 1) {
      break; // The streak is broken
    }
  }

  return consecutiveDays;
}

class _HomeBodyState extends State<HomeBody> {
  bool _isExpanded = false;
  final Duration _animationDuration = const Duration(milliseconds: 200);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<JournalCubit, JournalState>(
      listener: (context, state) {
        if (state is JournalError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is JournalsLoaded) {
          return Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: context.width * 0.04,
                  vertical: context.height * 0.03,
                ),
                padding: const EdgeInsets.all(20),
                height: context.height * 0.25,
                width: context.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(context.isDartMode
                        ? MediaRes.homeBackgroundDark
                        : MediaRes.homeBackgroundLight),
                    fit: BoxFit.cover,
                  ),
                  color: context.theme.colorScheme.primary,
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat.yMMMMd('en_US').format(DateTime.now()),
                      style: context.theme.textTheme.displayLarge,
                    ),
                    SizedBox(height: context.height * 0.03),
                    Text(
                      state.journals.length.toString(),
                      style: context.theme.textTheme.displayLarge,
                    ),
                    Text(
                      'Entries',
                      style: context.theme.textTheme.displaySmall,
                    ),
                    SizedBox(height: context.height * 0.03),
                    Text(
                      'You\'re on a roll! That\'s ${_consecutiveDays(state.journals)} day(s) in a row!',
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: context.height * 0.05,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 17,
                  ),
                  backgroundColor: context.theme.colorScheme.primary,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    _isExpanded = !_isExpanded; // Toggle button visibility
                  });
                },
                child: const Text(
                  'Start Today\'s Journal',
                ),
              ),
              SizedBox(
                height: context.height * 0.08,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  AnimatedContainer(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: const DecorationImage(
                        opacity: 0.5,
                        image: AssetImage(
                          MediaRes.pickedImageFormBackground,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                    duration: _animationDuration,
                    height: _isExpanded ? context.width * 0.45 : 0,
                    width: _isExpanded ? context.width * 0.45 : 0,
                    child: Center(
                      child: TextButton(
                        style: ButtonStyle(
                          fixedSize: MaterialStateProperty.all(
                            Size(context.width * 0.5, context.width * 0.5),
                          ),

                          //Rectangular shape
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0),
                            ),
                          ),
                        ),
                        onPressed: () {
                          showModalBottomSheet<void>(
                              context: context,
                              backgroundColor:
                                  context.theme.colorScheme.background,
                              isScrollControlled: true,
                              showDragHandle: true,
                              elevation: 0,
                              useSafeArea: true,
                              builder: (_) => const AddPickJournalView());
                        },
                        child: Text(
                          'Journal with\nMy Photo',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: context.theme.colorScheme.onPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  AnimatedContainer(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: const DecorationImage(
                        opacity: 0.6,
                        image: AssetImage(
                          MediaRes.generatdImageFormBackground,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                    duration: _animationDuration,
                    height: _isExpanded ? context.width * 0.45 : 0,
                    width: _isExpanded ? context.width * 0.45 : 0,
                    child: Center(
                      child: TextButton(
                        style: ButtonStyle(
                          fixedSize: MaterialStateProperty.all(
                            Size(context.width * 0.6, context.width * 0.5),
                          ),

                          //Rectangular shape
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0),
                            ),
                          ),
                        ),
                        onPressed: () {
                          showModalBottomSheet<void>(
                              context: context,
                              backgroundColor:
                                  context.theme.colorScheme.background,
                              isScrollControlled: true,
                              showDragHandle: true,
                              elevation: 0,
                              useSafeArea: true,
                              builder: (_) => const AddGenJournalView());
                        },
                        child: Text(
                          'Journal with\nGenerated Image',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: context.theme.colorScheme.onPrimary,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
