import 'package:flutter/material.dart';
import 'package:memoircanvas/core/common/widgets/gradient_background.dart';
import 'package:memoircanvas/core/res/media_res.dart';
import 'package:memoircanvas/src/home/presentation/refactors/home_body.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Memoir Canvas'),
      ),
      body: const GradientBackground(
        image: MediaRes.homeGradientBackground,
        child: HomeBody(),
      ),
    );
  }
}
