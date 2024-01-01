import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:memoircanvas/core/extensions/context_extension.dart';
import 'package:memoircanvas/core/utils/core_utils.dart';
import 'package:memoircanvas/src/journal/domain/entities/journal.dart';
import 'package:memoircanvas/src/journal/presentation/cubit/journal_cubit.dart';
import 'package:memoircanvas/src/journal/presentation/utils/weather.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class JournalTile extends StatefulWidget {
  const JournalTile({
    required this.journal,
    super.key,
  });

  final Journal journal;

  @override
  State<JournalTile> createState() => _JournalTileState();
}

class _JournalTileState extends State<JournalTile> {
  ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Column(
        children: [
          Screenshot(
            controller: screenshotController,
            child: Container(
              decoration: BoxDecoration(
                color: context.theme.colorScheme.background,
              ),
              padding: const EdgeInsets.all(30),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DateFormat.yMMMMd('en_US')
                              .format(widget.journal.createdAt),
                          style: context.theme.textTheme.displayMedium,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5, right: 5),
                          child: Icon(
                            Weather().getIcon(widget.journal.weather),
                            color: context.theme.colorScheme.onPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  CachedNetworkImage(
                    width: context.width,
                    height: context.width * 0.9,
                    imageUrl: widget.journal.imageURL,
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
                    widget.journal.title,
                    style: context.theme.textTheme.displayMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.journal.diary,
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                style: ButtonStyle(
                  fixedSize:
                      MaterialStateProperty.all<Size>(const Size.fromWidth(80)),
                  padding: MaterialStateProperty.all<EdgeInsets>(
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 3)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  backgroundColor: MaterialStateProperty.all<Color>(
                    context.theme.colorScheme.error,
                  ),
                  foregroundColor: MaterialStateProperty.all<Color>(
                    Colors.white,
                  ),
                ),
                onPressed: () {
                  CoreUtils.showCustomDialog(context,
                      height: 180,
                      width: 310,
                      title: 'Delete',
                      content: 'Are you sure you want to delete this journal?',
                      buttonHighlightColor: context.theme.colorScheme.error,
                      buttonTextColor: Colors.white,
                      actionText: 'Delete', action: () {
                    setState(() {
                      context
                          .read<JournalCubit>()
                          .deleteJournal(widget.journal.id);
                    });
                    Navigator.pop(context);
                  });
                },
                child: const Text(
                  'Delete',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 20),
              TextButton(
                style: ButtonStyle(
                  fixedSize:
                      MaterialStateProperty.all<Size>(const Size.fromWidth(80)),
                  padding: MaterialStateProperty.all<EdgeInsets>(
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 3)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  backgroundColor: MaterialStateProperty.all<Color>(
                    context.theme.colorScheme.primary,
                  ),
                  foregroundColor: MaterialStateProperty.all<Color>(
                    Colors.white,
                  ),
                ),
                onPressed: () {
                  screenshotController.capture().then((image) async {
                    final directory = await getTemporaryDirectory();
                    final imagePath = '${directory.path}/${DateTime.now()}.png';
                    File(imagePath).writeAsBytesSync(image!);

                    await Share.shareXFiles([XFile(imagePath)]);
                  });
                },
                child: const Text(
                  'Share',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
