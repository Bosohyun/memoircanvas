import 'package:flutter/material.dart';
import 'package:memoircanvas/core/extensions/context_extension.dart';

import 'package:memoircanvas/src/home/presentation/refactors/home_body.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Memoir Canvas',
          style: context.theme.textTheme.displayLarge,
        ),
      ),
      body: const SafeArea(child: HomeBody()),
    );
  }
}
