import 'package:flutter/material.dart';
import 'package:memoircanvas/core/common/widgets/nested_back_button.dart';
import 'package:memoircanvas/core/extensions/context_extension.dart';
import 'package:memoircanvas/src/premium/presentation/widgets/subscription_card.dart';

class Premium extends StatefulWidget {
  const Premium({super.key});

  static const routeName = '/premium';

  @override
  State<Premium> createState() => _PremiumState();
}

class _PremiumState extends State<Premium> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: context.theme.colorScheme.background,
        appBar: AppBar(
          title: Text(
            'Premium',
            style: context.theme.textTheme.displayLarge,
          ),
          leading: const NestedBackButton(),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SubscriptionCard(
                title: 'Monthly',
                onPressed: () {},
              ),
              SubscriptionCard(
                title: 'Yearly',
                onPressed: () {},
              ),
            ],
          ),
        ));
  }
}
