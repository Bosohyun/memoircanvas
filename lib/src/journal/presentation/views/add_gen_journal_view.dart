import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memoircanvas/core/common/app/providers/user_provider.dart';

import 'package:memoircanvas/core/common/widgets/nested_back_button.dart';
import 'package:memoircanvas/core/extensions/context_extension.dart';

import 'package:memoircanvas/core/utils/core_utils.dart';
import 'package:memoircanvas/src/journal/data/models/journal_model.dart';
import 'package:memoircanvas/src/journal/presentation/cubit/journal_cubit.dart';

import 'package:memoircanvas/src/journal/presentation/widgets/journal_preview.dart';
import 'package:memoircanvas/src/journal/presentation/widgets/write_gen_journal_form.dart';
import 'package:memoircanvas/src/premium/presentation/utils/stripe_data_util.dart';
import 'package:memoircanvas/src/premium/presentation/utils/user_db_service.dart';

class AddGenJournalView extends StatefulWidget {
  const AddGenJournalView({super.key});

  @override
  State<AddGenJournalView> createState() => _JournalViewState();
}

class _JournalViewState extends State<AddGenJournalView> {
  late StripeData stripeData;
  late SubscriptionStatus subscriptionStatus;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController journalController = TextEditingController();
  final TextEditingController weatherController = TextEditingController();
  JournalModel tempJournal = JournalModel.empty();
  final FocusNode textFocusNode = FocusNode();

  final formKey = GlobalKey<FormState>();
  loading(String msg) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(msg),
            const SizedBox(
              height: 10,
            ),
            const CircularProgressIndicator()
          ],
        ),
      ),
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
    // trialDays is lower than 0 trialDays will be 0

    int trialDays = (14 -
                DateTime.now()
                    .difference(context.read<UserProvider>().user!.createdAt!)
                    .inDays) <
            0
        ? 0
        : 14 -
            DateTime.now()
                .difference(context.read<UserProvider>().user!.createdAt!)
                .inDays;

//  return FutureBuilder(
//       future: StripeDataUtils.fetchStripeData(),
//       builder: (context, snapshot) {
//         if (snapshot.hasData == false) {
//           return loading('Loading Stripe Data...');
//         }

//         stripeData = snapshot.data!;

//         if (loadingPayment) return loading('Processing payment...');
    return FutureBuilder(
        future: StripeDataUtils.fetchStripeData(),
        builder: (context, snapshot) {
          if (snapshot.hasData == false) {
            return loading('Loading Stripe Data...');
          }

          stripeData = snapshot.data!;

          return StreamBuilder<SubscriptionStatus>(
              stream: UserDbService(
                uid: context.userProvider.user!.uid,
                stripeData: stripeData,
              ).checkSubscriptionIsActive,
              builder: (context, snapshot) {
                if (snapshot.hasData == false) {
                  return loading('Checking Subscription Data...');
                }

                subscriptionStatus = snapshot.data!;

                return Scaffold(
                  backgroundColor: context.theme.colorScheme.background,
                  appBar: AppBar(
                    leading: const NestedBackButton(),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (!subscriptionStatus.subIsActive)
                          Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: context.theme.colorScheme.primary,
                                ),
                                child: const Text(
                                  'Trial Mode',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '$trialDays days left',
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.end,
                              )
                            ],
                          ),
                      ],
                    ),
                  ),
                  body: BlocConsumer<JournalCubit, JournalState>(
                    listener: (context, state) {
                      if (state is JournalImageGenError) {
                        CoreUtils.showSnackBar(context, state.message);
                      } else if (state is JournalImageGenerated) {
                        tempJournal =
                            tempJournal.copyWith(imageURL: state.imageUrl);
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
                              const SizedBox(height: 20),
                              Align(
                                child: Text(
                                    'You can generate ${context.read<UserProvider>().user!.remainingGen} more images today.',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color:
                                          context.theme.colorScheme.onPrimary,
                                    )),
                              ),
                              const SizedBox(height: 20),
                              Align(
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    fixedSize: MaterialStateProperty.all<Size>(
                                      const Size(180, 60),
                                    ),
                                    elevation:
                                        MaterialStateProperty.all<double>(0),
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(context
                                            .theme.colorScheme.background),
                                    foregroundColor:
                                        MaterialStateProperty.all<Color>(
                                      Colors.white,
                                    ),
                                  ),

                                  onPressed: () async {
                                    if (trialDays == 0 &&
                                        !subscriptionStatus.subIsActive) {
                                      Navigator.of(context)
                                          .pushNamed('/premium');
                                    }

                                    if (formKey.currentState!.validate()) {
                                      tempJournal = tempJournal.copyWith(
                                        title: titleController.text,
                                        weather: weatherController.text
                                            .toLowerCase(),
                                        diary: journalController.text,
                                        createdAt: DateTime.now(),
                                      );

                                      if (context
                                              .read<UserProvider>()
                                              .user!
                                              .remainingGen! >
                                          0) {
                                        await context
                                            .read<JournalCubit>()
                                            .genJournalImage(tempJournal.diary);
                                        if (context.mounted) {
                                          showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            useSafeArea: true,
                                            builder: (_) => Dialog(
                                              insetPadding:
                                                  const EdgeInsets.all(20),
                                              alignment: Alignment.lerp(
                                                  Alignment.bottomCenter,
                                                  Alignment.topCenter,
                                                  0.8),
                                              backgroundColor: context
                                                  .theme.colorScheme.background,
                                              child: JournalPreview(
                                                tempJournal: tempJournal,
                                              ),
                                            ),
                                          );
                                        }
                                      } else {
                                        CoreUtils.showSnackBar(context,
                                            'You have no more image generation');
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
              });
        });
  }
}
