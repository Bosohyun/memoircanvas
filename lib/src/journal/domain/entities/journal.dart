import 'package:equatable/equatable.dart';

class Journal extends Equatable {
  const Journal({
    required this.id,
    required this.userId,
    required this.title,
    required this.weather,
    required this.imageURL,
    required this.diary,
    required this.createdAt,
  });

  Journal.empty()
      : this(
          id: '_empty.id',
          userId: '_empty.userId',
          title: '_empty.title',
          weather: '_empty.weather',
          imageURL: '_empty.imageURL',
          diary: '_empty.diary',
          createdAt: DateTime.now(),
        );

  final String id;
  final String userId;
  final String title;
  final String weather;
  final String imageURL;
  final String diary;
  final DateTime createdAt;

  @override
  List<Object?> get props => [id];
}
