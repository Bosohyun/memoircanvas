import 'package:flutter/material.dart';
import 'package:memoircanvas/src/journal/domain/entities/journal.dart';

class JournalTile extends StatelessWidget {
  const JournalTile({required this.journal, super.key, this.onTap});

  final Journal journal;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 54,
        child: Column(
          children: [
            SizedBox(
              height: 54,
              width: 54,
              child: Image.network(
                journal.imageURL,
                height: 32,
                width: 32,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              journal.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
