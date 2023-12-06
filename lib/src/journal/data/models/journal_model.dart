import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:memoircanvas/core/utils/typedefs.dart';
import 'package:memoircanvas/src/journal/domain/entities/journal.dart';

class JournalModel extends Journal {
  const JournalModel({
    required super.id,
    required super.title,
    required super.weather,
    required super.imageURL,
    required super.diary,
    required super.createdAt,
  });

  JournalModel.empty()
      : this(
          id: '_empty.id',
          title: '_empty.title',
          weather: '_empty.weather',
          imageURL: '_empty.imageURL',
          diary: '_empty.diary',
          createdAt: DateTime.now(),
        );

  JournalModel.fromMap(DataMap map)
      : super(
          id: map['id'] as String,
          title: map['title'] as String,
          weather: map['weather'] as String,
          imageURL: map['imageURL'] as String,
          diary: map['diary'] as String,
          createdAt: (map['createdAt'] as Timestamp).toDate(),
        );

  JournalModel copyWith({
    String? id,
    String? title,
    String? weather,
    String? imageURL,
    String? diary,
    DateTime? createdAt,
  }) {
    return JournalModel(
      id: id ?? this.id,
      title: title ?? this.title,
      weather: weather ?? this.weather,
      imageURL: imageURL ?? this.imageURL,
      diary: diary ?? this.diary,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  DataMap toMap() {
    return {
      'id': id,
      'title': title,
      'weather': weather,
      'imageURL': imageURL,
      'diary': diary,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
