import 'dart:io';
import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:memoircanvas/core/extensions/context_extension.dart';
import 'package:memoircanvas/src/journal/data/models/journal_model.dart';
import 'package:memoircanvas/src/journal/domain/usecases/add_journal.dart';
import 'package:memoircanvas/src/journal/presentation/cubit/journal_cubit.dart';
import 'package:memoircanvas/src/journal/presentation/utils/journal_util.dart';

import 'package:memoircanvas/src/journal/presentation/utils/weather.dart';

class JournalPreview extends StatefulWidget {
  const JournalPreview(
      {required this.tempJournal, this.pickedImage, super.key});

  final JournalModel tempJournal;
  final XFile? pickedImage;

  @override
  State<JournalPreview> createState() => _JournalPreviewState();
}

class _JournalPreviewState extends State<JournalPreview> {
  bool isSaving = false;
  bool isDiscardVisible = true;
  bool isDone = false;

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
      child: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
        ),
        shrinkWrap: true,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat.yMMMMd('en_US')
                      .format(widget.tempJournal.createdAt),
                  style: context.theme.textTheme.displayMedium,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 5, right: 5),
                  child: Icon(
                    Weather().getIcon(widget.tempJournal.weather),
                    color: context.theme.colorScheme.onPrimary,
                  ),
                ),
              ],
            ),
          ),
          (widget.pickedImage != null)
              ? Image(
                  image: FileImage(
                    File(widget.pickedImage!.path),
                  ),
                )
              : Image.network(
                  widget.tempJournal.imageURL,
                  fit: BoxFit.fill,
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
          const SizedBox(height: 10),
          Text(
            widget.tempJournal.title,
            style: context.theme.textTheme.displayMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            widget.tempJournal.diary,
            style: const TextStyle(
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 20),
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              AnimatedAlign(
                duration: const Duration(milliseconds: 500),
                alignment:
                    isSaving ? Alignment.center : const Alignment(-0.5, 0.0),
                child: ElevatedButton(
                  style: ButtonStyle(
                    elevation: isSaving
                        ? MaterialStateProperty.all<double>(0)
                        : MaterialStateProperty.all<double>(2),
                    backgroundColor: isSaving
                        ? MaterialStateProperty.all<Color>(
                            context.theme.colorScheme.background)
                        : MaterialStateProperty.all<Color>(
                            context.theme.colorScheme.primary),
                    foregroundColor: MaterialStateProperty.all<Color>(
                      Colors.white,
                    ),
                    fixedSize: MaterialStateProperty.all<Size>(
                      const Size(100, 40),
                    ),
                  ),
                  onPressed: () async {
                    if (!isSaving && !isDone) {
                      setState(() {
                        isSaving = true;
                        isDiscardVisible = false;
                      });
                    }
                    Uint8List imageBytes;

                    if (widget.pickedImage != null) {
                      imageBytes = await widget.pickedImage!.readAsBytes();
                    } else {
                      imageBytes = await JournalUtils.fetchImageBytes(
                          imageUrl: widget.tempJournal.imageURL);
                    }

                    if (context.mounted) {
                      await context.read<JournalCubit>().addJournal(
                            AddJournalParams(
                              imageBytes,
                              widget.tempJournal,
                            ),
                          );
                    }
                    setState(() {
                      isDone = true;
                    });

                    Future.delayed(const Duration(milliseconds: 1000), () {
                      Navigator.pop(context);
                    });
                  },
                  child: isDone
                      ? Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.green,
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.done,
                              color: Colors.white,
                            ),
                          ),
                        )
                      : isSaving
                          ? const CircularProgressIndicator()
                          : const AutoSizeText(
                              'Save',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                ),
              ),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 500),
                opacity: isDiscardVisible ? 1 : 0,
                child: AnimatedAlign(
                  duration: const Duration(milliseconds: 500),
                  alignment: isDiscardVisible
                      ? const Alignment(0.5, 0.0)
                      : Alignment.center,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all<Size>(
                        const Size(100, 40),
                      ),
                      backgroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromARGB(255, 216, 92, 83),
                      ),
                      foregroundColor: MaterialStateProperty.all<Color>(
                        Colors.white,
                      ),
                    ),
                    onPressed: () {
                      context.read<JournalCubit>().reset();
                      // Discard button logic
                      Navigator.pop(context);
                    },
                    child: const AutoSizeText(
                      'Discard',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
