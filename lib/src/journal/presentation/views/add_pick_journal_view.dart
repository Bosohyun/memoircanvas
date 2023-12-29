import 'dart:io';

import 'package:flutter/material.dart';

import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:memoircanvas/core/common/widgets/nested_back_button.dart';
import 'package:memoircanvas/core/extensions/context_extension.dart';
import 'package:memoircanvas/core/utils/core_utils.dart';
import 'package:memoircanvas/src/journal/data/models/journal_model.dart';

import 'package:memoircanvas/src/journal/presentation/utils/journal_util.dart';
import 'package:memoircanvas/src/journal/presentation/widgets/journal_preview.dart';
import 'package:memoircanvas/src/journal/presentation/widgets/write_pick_journal_form.dart';

class AddPickJournalView extends StatefulWidget {
  const AddPickJournalView({super.key});

  @override
  State<AddPickJournalView> createState() => _AddPickJournalViewState();
}

class _AddPickJournalViewState extends State<AddPickJournalView> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController journalController = TextEditingController();
  final TextEditingController weatherController = TextEditingController();
  JournalModel tempJournal = JournalModel.empty();
  final FocusNode textFocusNode = FocusNode();

  final formKey = GlobalKey<FormState>();

  XFile? pickedImage;

  Future<void> onClickedPickImage({required bool isGallery}) async {
    final file = await JournalUtils.pickMedia(isGallery: isGallery);

    setState(() {
      pickedImage = file;
    });
  }

  Future<CroppedFile?> cropSquareImage(File imageFile) async {
    return await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
      ],
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    weatherController.dispose();
    journalController.dispose();
    textFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.colorScheme.background,
      appBar: AppBar(
        leading: const NestedBackButton(),
      ),
      body: SafeArea(
        child: Center(
          child: ListView(
            padding: EdgeInsets.symmetric(
              horizontal: context.width * 0.05,
            ),
            shrinkWrap: true,
            children: [
              WritePickJournalForm(
                weatherController: weatherController,
                titleController: titleController,
                journalController: journalController,
                formKey: formKey,
                focusNode: textFocusNode,
                pickedImage: pickedImage,
                onClickPickImage: onClickedPickImage,
              ),
              Align(
                child: ElevatedButton(
                    style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all<Size>(
                        const Size(180, 60),
                      ),
                      elevation: MaterialStateProperty.all<double>(0),
                      backgroundColor: MaterialStateProperty.all<Color>(
                          context.theme.colorScheme.primary),
                      foregroundColor: MaterialStateProperty.all<Color>(
                        Colors.white,
                      ),
                    ),
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        tempJournal = tempJournal.copyWith(
                          title: titleController.text,
                          weather: weatherController.text.toLowerCase(),
                          diary: journalController.text,
                          createdAt: DateTime.now(),
                        );

                        if (pickedImage == null) {
                          CoreUtils.showSnackBar(
                              context, 'Please pick an image');
                          return;
                        }

                        if (context.mounted) {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            useSafeArea: true,
                            builder: (_) => Dialog(
                              insetPadding: const EdgeInsets.all(20),
                              alignment: Alignment.lerp(Alignment.bottomCenter,
                                  Alignment.topCenter, 0.8),
                              backgroundColor:
                                  context.theme.colorScheme.background,
                              child: JournalPreview(
                                tempJournal: tempJournal,
                                pickedImage: pickedImage,
                              ),
                            ),
                          );
                        }
                      }
                    },
                    child: const Text(
                      'Finish Entry',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
              ),
              const SizedBox(height: 30)
            ],
          ),
        ),
      ),
    );
  }
}
