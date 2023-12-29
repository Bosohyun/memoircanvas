import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:memoircanvas/core/extensions/context_extension.dart';
import 'package:memoircanvas/src/journal/domain/entities/journal.dart';
import 'package:memoircanvas/src/journal/presentation/utils/weather.dart';

class JournalTile extends StatelessWidget {
  const JournalTile({required this.journal, super.key, this.onTap});

  final Journal journal;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: context.theme.colorScheme.background,
        boxShadow: [
          BoxShadow(
            color: context.theme.colorScheme.onPrimary.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      width: double.infinity,
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormat.yMMMMd('en_US').format(journal.createdAt),
                style: context.theme.textTheme.displayMedium,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 5, right: 5),
                child: Icon(
                  Weather().getIcon(journal.weather),
                  color: context.theme.colorScheme.onPrimary,
                ),
              ),
            ],
          ),
        ),
        CachedNetworkImage(
          width: context.width,
          height: context.width * 0.9,
          imageUrl: journal.imageURL,
          fit: BoxFit.fill,
          progressIndicatorBuilder: (context, url, progress) {
            return Center(
              child: CircularProgressIndicator(
                value: progress.progress,
              ),
            );
          },
        ),
        const SizedBox(height: 10),
        Text(
          journal.title,
          style: context.theme.textTheme.displayMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Text(
          journal.diary,
          style: const TextStyle(
            fontSize: 20,
          ),
        ),
      ]),
    );
  }
}
