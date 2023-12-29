import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:memoircanvas/core/extensions/context_extension.dart';
import 'package:memoircanvas/src/journal/domain/entities/journal.dart';
import 'package:memoircanvas/src/journal/presentation/cubit/journal_cubit.dart';

class JournalSmallTile extends StatefulWidget {
  const JournalSmallTile(
      {required this.journal, required this.onDateSelected, super.key});

  final Journal journal;
  final Function(DateTime, DateTime, bool) onDateSelected;

  @override
  State<JournalSmallTile> createState() => _JournalSmallTileState();
}

class _JournalSmallTileState extends State<JournalSmallTile> {
  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.48,
        children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              color: context.theme.colorScheme.error,
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Delete Journal'),
                        content: const Text(
                            'Are you sure you want to delete this journal?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              setState(() {
                                context
                                    .read<JournalCubit>()
                                    .deleteJournal(widget.journal.id);
                              });
                              Navigator.pop(context);
                            },
                            child: const Text('Delete',
                                style: TextStyle(color: Colors.red)),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Cancel'),
                          ),
                        ],
                      );
                    });
              },
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                  Text(
                    'Delete',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),

          //share
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              color: context.theme.colorScheme.primary,
              onPressed: () {},
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.share,
                    color: Colors.white,
                  ),
                  Text(
                    'Share',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: ListTile(
          onTap: () {
            widget.onDateSelected(
              widget.journal.createdAt,
              widget.journal.createdAt,
              false,
            );
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          tileColor: context.theme.colorScheme.primary.withOpacity(0.1),
          leading: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: context.theme.colorScheme.background,
                boxShadow: [
                  BoxShadow(
                    color: context.theme.colorScheme.onPrimary.withOpacity(0.2),
                    blurRadius: 5,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              height: 60,
              width: 60,
              child: CachedNetworkImage(
                imageUrl: widget.journal.imageURL,
                fit: BoxFit.fill,
                progressIndicatorBuilder: (context, url, progress) {
                  return Center(
                    child: CircularProgressIndicator(
                      value: progress.progress,
                    ),
                  );
                },
              )
              // child: Image.network(
              //   widget.journal.imageURL,
              //   fit: BoxFit.fill,
              //   loadingBuilder: (BuildContext context, Widget child,
              //       ImageChunkEvent? loadingProgress) {
              //     if (loadingProgress == null) {
              //       return child;
              //     } // Image is fully loaded
              //     return const Center(
              //       child: CircularProgressIndicator(),
              //     );
              //   },
              // ),

              //           CachedNetworkImage(
              // width: context.width,
              // height: context.width * 0.9,
              // imageUrl: journal.imageURL,
              // fit: BoxFit.fill,
              // progressIndicatorBuilder: (context, url, progress) {
              //   return Center(
              //     child: CircularProgressIndicator(
              //       value: progress.progress,
              //     ),
              //   );
              // },
              // ),
              ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.4,
                child: Text(
                  overflow: TextOverflow.ellipsis,
                  widget.journal.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                  ),
                ),
              ),
              Text(
                widget.journal.createdAt.year.toString() +
                    '/' +
                    widget.journal.createdAt.month.toString() +
                    '/' +
                    widget.journal.createdAt.day.toString(),
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          subtitle: Text(
            overflow: TextOverflow.ellipsis,
            widget.journal.diary,
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}
