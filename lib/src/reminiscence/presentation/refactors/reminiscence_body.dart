import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memoircanvas/core/extensions/context_extension.dart';
import 'package:memoircanvas/core/utils/core_utils.dart';
import 'package:memoircanvas/src/journal/domain/entities/journal.dart';

import 'package:memoircanvas/src/journal/presentation/cubit/journal_cubit.dart';

import 'package:memoircanvas/src/journal/presentation/widgets/journal_small_tile.dart';
import 'package:memoircanvas/src/journal/presentation/widgets/journal_tile.dart';
import 'package:memoircanvas/src/reminiscence/presentation/utils/utils.dart';
import 'package:table_calendar/table_calendar.dart';

class ReminiscenceBody extends StatefulWidget {
  const ReminiscenceBody({super.key});

  @override
  State<ReminiscenceBody> createState() => _ReminiscenceBodyState();
}

class _ReminiscenceBodyState extends State<ReminiscenceBody> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  late DateTime _selectedDay;
  late DateTime _focusedDay;
  late List<Journal> _filteredJournals;
  late Map<DateTime, List<Event>> _events;
  bool _isAll = false;

  List<Event> _getEventsForDay(DateTime day) {
    return _events[day] ?? [];
  }

  void _getJournals() {
    context.read<JournalCubit>().getJournals();
  }

  void _updateSelectedDay(
      DateTime selectedDay, DateTime focusedDay, bool isAll) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
      _isAll = false;
    });
  }

  @override
  void initState() {
    super.initState();

    _selectedDay = DateTime.now();
    _focusedDay = DateTime.now();
    _filteredJournals = [];
    _events = {};

    _getJournals();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<JournalCubit, JournalState>(listener: (_, state) {
      if (state is JournalError) {
        CoreUtils.showSnackBar(context, state.message);
      } else if (state is JournalAdded) {
        CoreUtils.showSnackBar(context, 'Journal Added');
        _getJournals();
      } else if (state is JournalDeleted) {
        CoreUtils.showSnackBar(context, 'Journal Deleted');
        _getJournals();
      }
    }, builder: (context, state) {
      if (state is LoadingJournals) {
        return const Center(child: CircularProgressIndicator());
      } else if ((state is JournalsLoaded && state.journals.isEmpty) ||
          state is JournalError) {
        return const Center(
          child: Text(
            'No Journals',
          ),
        );
      } else if (state is JournalsLoaded) {
        _filteredJournals = state.journals
          ..sort(
            (a, b) => b.createdAt.compareTo(
              a.createdAt,
            ),
          );

        _events = {
          for (var journal in _filteredJournals)
            DateTime.utc(journal.createdAt.year, journal.createdAt.month,
                journal.createdAt.day): [
              Event(journal: journal),
            ]
        };

        return ListView(
          children: [
            TableCalendar(
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              calendarStyle: CalendarStyle(
                markerSize: 10.0,
                markerDecoration: BoxDecoration(
                    color: context.theme.colorScheme.primary,
                    shape: BoxShape.circle),
              ),
              onPageChanged: (focusedDay) {
                setState(() {
                  _focusedDay = focusedDay;
                });
              },
              onDaySelected: ((selectedDay, focusedDay) {
                setState(
                  () {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                    _isAll = false;
                  },
                );
              }),
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  setState(
                    () {
                      _calendarFormat = format;
                    },
                  );
                }
              },
              eventLoader: _getEventsForDay,
              availableCalendarFormats: const {
                CalendarFormat.month: 'Month',
                CalendarFormat.twoWeeks: '2 weeks',
              },
            ),
            Align(
              alignment: const Alignment(0.9, 0.0),
              child: TextButton(
                onPressed: () {
                  setState(
                    () {
                      _isAll = true;
                      //show all journals
                    },
                  );
                },
                child: Text(
                  'See All',
                  style: TextStyle(
                    color: context.theme.colorScheme.primary,
                  ),
                ),
              ),
            ),

            //show all journals
            if (_isAll)
              for (final journal in state.journals)
                JournalSmallTile(
                  journal: journal,
                  onDateSelected: _updateSelectedDay,
                ),

            if (!_isAll)
              for (final journal in _filteredJournals.where(
                (journal) => isSameDay(
                  journal.createdAt,
                  _selectedDay,
                ),
              ))
                JournalTile(
                  journal: journal,
                ),
          ],
        );
      }
      return const SizedBox.shrink();
    });
  }
}
