import 'package:flutter/material.dart';
import 'package:memoircanvas/core/extensions/context_extension.dart';
import 'package:memoircanvas/src/journal/data/models/journal_model.dart';

class JournalPreview extends StatelessWidget {
  const JournalPreview({required this.tempJournal, super.key});

  final JournalModel tempJournal;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: SizedBox(
        height: context.height * 0.5,
        width: context.width * 0.8,
        child: Column(children: [
          Text(
            tempJournal.title,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            tempJournal.diary,
            style: const TextStyle(
              fontSize: 20,
            ),
          ),
          Image.network(
            tempJournal.imageURL,
            fit: BoxFit.cover,
            loadingBuilder: (BuildContext context, Widget child,
                ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) {
                return child;
              } // Image is fully loaded
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ]),
      ),
    );
  }
}
