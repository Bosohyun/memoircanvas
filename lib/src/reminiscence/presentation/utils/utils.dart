import 'package:memoircanvas/src/journal/domain/entities/journal.dart';

class Event {
  final Journal journal;
  Event({required this.journal});

  @override
  String toString() => journal.title;
}
