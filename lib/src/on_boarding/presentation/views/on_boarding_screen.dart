import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memoircanvas/core/extensions/context_extension.dart';

import 'package:memoircanvas/src/on_boarding/domain/entities/page_content.dart';
import 'package:memoircanvas/src/on_boarding/presentation/cubit/on_boarding_cubit.dart';
import 'package:memoircanvas/src/on_boarding/presentation/widgets/on_boarding_body.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  static const routeName = '/';

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final pageController = PageController();

  @override
  void initState() {
    super.initState();
    context.read<OnBoardingCubit>().checkIfUserIsFirstTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.colorScheme.background,
      body: BlocConsumer<OnBoardingCubit, OnBoardingState>(
        listener: (context, state) {
          if (state is OnBoardingStatus && !state.isFirstTimer) {
            Navigator.pushReplacementNamed(context, '/home');
          } else if (state is UserCached) {
            Navigator.pushReplacementNamed(context, '/');
          }
        },
        builder: (context, state) {
          if (state is CheckingIfUserIsFirstTimer ||
              state is CachingFirstTimer) {
            return const CircularProgressIndicator();
          }

          return Stack(
            children: [
              PageView(
                controller: pageController,
                children: const [
                  OnBoardingBody(pageContent: PageContent.first()),
                  OnBoardingBody(pageContent: PageContent.second()),
                  OnBoardingBody(pageContent: PageContent.third()),
                ],
              )
            ],
          );
        },
      ),
    );
  }
}
