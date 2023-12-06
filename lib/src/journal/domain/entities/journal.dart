import 'package:equatable/equatable.dart';

class Journal extends Equatable {
  const Journal({
    required this.id,
    required this.title,
    required this.weather,
    required this.imageURL,
    required this.diary,
    required this.createdAt,
  });

  Journal.empty()
      : id = '',
        title = '',
        weather = '',
        imageURL = '',
        diary = '',
        createdAt = DateTime.now();

  final String id;
  final String title;
  final String weather;
  final String imageURL;
  final String diary;
  final DateTime createdAt;

  @override
  List<Object?> get props => [id];
}
