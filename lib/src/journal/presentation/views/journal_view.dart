import 'package:flutter/material.dart';
import 'package:memoircanvas/core/common/widgets/best_button.dart';
import 'package:memoircanvas/core/common/widgets/custom_button.dart';

import 'package:memoircanvas/core/common/widgets/gradient_background.dart';
import 'package:memoircanvas/core/common/widgets/nested_back_button.dart';
import 'package:memoircanvas/core/res/colors.dart';
import 'package:memoircanvas/core/res/fonts.dart';
import 'package:memoircanvas/core/res/media_res.dart';
import 'package:memoircanvas/core/utils/core_utils.dart';
import 'package:memoircanvas/src/journal/data/models/journal_model.dart';
import 'package:memoircanvas/src/journal/presentation/utils/journal_util.dart';

import 'package:memoircanvas/src/journal/presentation/widgets/journal_preview.dart';
import 'package:memoircanvas/src/journal/presentation/widgets/write_journal_form.dart';

class JournalView extends StatefulWidget {
  const JournalView({super.key});

  @override
  State<JournalView> createState() => _JournalViewState();
}

class _JournalViewState extends State<JournalView> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController journalController = TextEditingController();
  final JournalModel emptyJournal = JournalModel.empty();
  final FocusNode textFocusNode = FocusNode();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    titleController.dispose();
    journalController.dispose();
    textFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var keyboardIsOpen = MediaQuery.of(context).viewInsets.bottom != 0;
    var bottomPadding =
        keyboardIsOpen ? MediaQuery.of(context).viewInsets.bottom : 20.0;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Journal'),
        leading: const NestedBackButton(),
      ),
      body: GradientBackground(
        image: MediaRes.homeGradientBackground,
        child: Padding(
          padding: EdgeInsets.only(
            left: 40.0,
            right: 40.0,
            top: 20.0,
            bottom: bottomPadding,
          ),
          child: ListView(
            children: [
              const SizedBox(height: 100),
              WriteJournalForm(
                titleController: titleController,
                journalController: journalController,
                formKey: formKey,
                focusNode: textFocusNode,
              ),
              const SizedBox(height: 100),
              Align(
                child: BestButton(
                  text: 'Abracadabra!',
                  onPressed: () async {
                    var tempJournal = emptyJournal.copyWith(
                      title: titleController.text,
                      diary: journalController.text,
                    );
                    final imageUrl =
                        'https://firebasestorage.googleapis.com/v0/b/memoircanvas-f3c8b.appspot.com/o/pexels-mathias-reding-18111091.jpg?alt=media&token=159cdce6-7695-423c-810b-3950546e23bd';

                    // await JournalUtils.generateImage(
                    //     journal: journalController.text, context: context);

                    if (imageUrl != null) {
                      tempJournal = tempJournal.copyWith(imageURL: imageUrl);
                      if (context.mounted) {
                        showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (_) => Dialog(
                            child: JournalPreview(
                              tempJournal: tempJournal,
                            ),
                          ),
                        );
                      }
                    } else {
                      if (context.mounted) {
                        CoreUtils.showSnackBar(
                            context, 'Something went wrong, try again later');
                      }
                    }
                  },
                ),
              ),

              // Align(
              //   child: CustomButtonWidget(
              //     text: 'Abracadabra!',
              //     onPressed: () async {
              //       var tempJournal = emptyJournal.copyWith(
              //         title: titleController.text,
              //         diary: journalController.text,
              //       );
              //       final imageUrl =
              //           'https://firebasestorage.googleapis.com/v0/b/memoircanvas-f3c8b.appspot.com/o/pexels-mathias-reding-18111091.jpg?alt=media&token=159cdce6-7695-423c-810b-3950546e23bd';

              //       // await JournalUtils.generateImage(
              //       //     journal: journalController.text, context: context);

              //       if (imageUrl != null) {
              //         tempJournal = tempJournal.copyWith(imageURL: imageUrl);
              //         if (context.mounted) {
              //           showDialog(
              //             context: context,
              //             barrierDismissible: true,
              //             builder: (_) => Dialog(
              //               child: JournalPreview(
              //                 tempJournal: tempJournal,
              //               ),
              //             ),
              //           );
              //         }
              //       } else {
              //         if (context.mounted) {
              //           CoreUtils.showSnackBar(
              //               context, 'Something went wrong, try again later');
              //         }
              //       }
              //     },
              //     options: CustomButtonOptions(
              //       width: 200.0,
              //       height: 50.0,
              //       padding: const EdgeInsetsDirectional.fromSTEB(
              //           0.0, 0.0, 0.0, 0.0),
              //       iconPadding: const EdgeInsetsDirectional.fromSTEB(
              //           0.0, 0.0, 0.0, 0.0),
              //       color: Colours.primaryColour,
              //       textStyle: TextStyle(
              //         fontFamily: Fonts.aeonik,
              //         fontWeight: FontWeight.bold,
              //         color: Colors.white,
              //       ),
              //       elevation: 3.0,
              //       borderSide: BorderSide(
              //         color: Colors.transparent,
              //         width: 1.0,
              //       ),
              //       borderRadius: BorderRadius.circular(40.0),
              //     ),
              //   ),
              // )
              // ElevatedButton(
              //   style: ElevatedButton.styleFrom(
              //     padding: const EdgeInsets.symmetric(
              //       horizontal: 50,
              //       vertical: 17,
              //     ),
              //     backgroundColor: Colours.primaryColour,
              //     foregroundColor: Colors.white,
              //   ),
              //   onPressed: () async {
              //     var tempJournal = emptyJournal.copyWith(
              //       title: titleController.text,
              //       diary: journalController.text,
              //     );
              //     final imageUrl =
              //         'https://firebasestorage.googleapis.com/v0/b/memoircanvas-f3c8b.appspot.com/o/pro1.png?alt=media&token=e65da818-b2a6-441b-b573-8aabdf9fdb35';
              //     // await JournalUtils.generateImage(
              //     //     journal: journalController.text, context: context);

              //     if (imageUrl != null) {
              //       print('imageUrl: $imageUrl');
              //       tempJournal = tempJournal.copyWith(imageURL: imageUrl);
              //       if (context.mounted) {
              //         showDialog(
              //           context: context,
              //           barrierDismissible: true,
              //           barrierColor: Colors.white,
              //           useSafeArea: true,
              //           builder: (_) => JournalPreview(
              //             tempJournal: tempJournal,
              //           ),
              //         );
              //       }
              //     } else {
              //       print('imageUrl: $imageUrl');
              //       if (context.mounted) {
              //         CoreUtils.showSnackBar(
              //             context, 'Something went wrong, try again later');
              //       }
              //     }
              //   },
              //   child: const Text(
              //     'AbraKadabra!',
              //     style: TextStyle(
              //       fontFamily: Fonts.aeonik,
              //       fontWeight: FontWeight.bold,
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
