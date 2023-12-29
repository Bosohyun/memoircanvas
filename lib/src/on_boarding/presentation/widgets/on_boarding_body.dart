import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:memoircanvas/core/extensions/context_extension.dart';

import 'package:memoircanvas/src/on_boarding/domain/entities/page_content.dart';
import 'package:memoircanvas/src/on_boarding/presentation/cubit/on_boarding_cubit.dart';
import 'package:memoircanvas/src/on_boarding/presentation/widgets/on_boarding_button.dart';

class OnBoardingBody extends StatelessWidget {
  const OnBoardingBody({required this.pageContent, super.key});

  final PageContent pageContent;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          pageContent.image,
          height: context.height * .35,
        ),
        SizedBox(
          height: context.height * .03,
        ),
        Padding(
            padding: const EdgeInsets.all(20).copyWith(bottom: 0),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    pageContent.title,
                    style: context.theme.textTheme.displayLarge,
                    textAlign: TextAlign.left,
                  ),
                ),
                SizedBox(
                  height: context.height * .03,
                ),
                Text(
                  pageContent.description,
                  style: context.theme.textTheme.displaySmall,
                ),
                SizedBox(
                  height: context.height * .10,
                ),
                OnBoardinigButton(
                  text: "Get Started",
                  onPressed: () {
                    context.read<OnBoardingCubit>().cacheFirstTimer();
                  },
                ),
              ],
            ))
      ],
    );
  }
}
