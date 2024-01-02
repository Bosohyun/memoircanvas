import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:memoircanvas/core/common/widgets/nested_back_button.dart';
import 'package:memoircanvas/core/extensions/context_extension.dart';

import 'package:memoircanvas/core/utils/core_utils.dart';
import 'package:memoircanvas/src/journal/data/models/journal_model.dart';
import 'package:memoircanvas/src/journal/presentation/cubit/journal_cubit.dart';

import 'package:memoircanvas/src/journal/presentation/widgets/journal_preview.dart';
import 'package:memoircanvas/src/journal/presentation/widgets/write_gen_journal_form.dart';

class AddGenJournalView extends StatefulWidget {
  const AddGenJournalView({super.key});

  @override
  State<AddGenJournalView> createState() => _JournalViewState();
}

class _JournalViewState extends State<AddGenJournalView> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController journalController = TextEditingController();
  final TextEditingController weatherController = TextEditingController();
  JournalModel tempJournal = JournalModel.empty();
  final FocusNode textFocusNode = FocusNode();

  final formKey = GlobalKey<FormState>();

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
      body: BlocConsumer<JournalCubit, JournalState>(
        listener: (context, state) {
          if (state is JournalImageGenError) {
            CoreUtils.showSnackBar(context, state.message);
          } else if (state is JournalImageGenerated) {
            tempJournal = tempJournal.copyWith(imageURL: state.imageUrl);
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Center(
              child: ListView(
                padding: EdgeInsets.symmetric(
                  horizontal: context.width * 0.05,
                ),
                shrinkWrap: true,
                children: [
                  WriteGenJournalForm(
                    weatherController: weatherController,
                    titleController: titleController,
                    journalController: journalController,
                    formKey: formKey,
                    focusNode: textFocusNode,
                  ),
                  const SizedBox(height: 30),
                  Align(
                    child: ElevatedButton(
                      style: ButtonStyle(
                        fixedSize: MaterialStateProperty.all<Size>(
                          const Size(180, 60),
                        ),
                        elevation: MaterialStateProperty.all<double>(0),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            context.theme.colorScheme.background),
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

                          await context
                              .read<JournalCubit>()
                              .genJournalImage(tempJournal.diary);
                          if (context.mounted) {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              useSafeArea: true,
                              builder: (_) => Dialog(
                                insetPadding: const EdgeInsets.all(20),
                                alignment: Alignment.lerp(
                                    Alignment.bottomCenter,
                                    Alignment.topCenter,
                                    0.8),
                                backgroundColor:
                                    context.theme.colorScheme.background,
                                child: JournalPreview(
                                  tempJournal: tempJournal,
                                ),
                              ),
                            );
                          }
                        }
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: state is JournalImageGenerating ||
                                state is JournalImageGenerated
                            ? 60
                            : 180,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color: state is JournalImageGenerated
                              ? Colors.green
                              : context.theme.colorScheme.primary,
                        ),
                        child: state is JournalImageGenerating
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : state is JournalImageGenerated
                                ? const Icon(
                                    Icons.done,
                                    color: Colors.white,
                                    size: 35,
                                  )
                                : const Text(
                                    'Abracadabra!',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                      ),

                      // },
                    ),
                  ),
                  const SizedBox(height: 30)
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
