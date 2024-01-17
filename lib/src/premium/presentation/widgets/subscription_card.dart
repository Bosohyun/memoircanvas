import 'package:flutter/material.dart';
import 'package:memoircanvas/core/extensions/context_extension.dart';

class SubscriptionCard extends StatefulWidget {
  const SubscriptionCard(
      {required this.title, required this.onPressed, super.key});

  final String title;
  final VoidCallback onPressed;

  @override
  State<SubscriptionCard> createState() => _SubscriptionCardState();
}

class _SubscriptionCardState extends State<SubscriptionCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(
          10,
        ),
      ),
      child: Material(
        child: InkWell(
          onTap: widget.onPressed,
          child: Container(
            width: 200.0,
            height: 100.0,
          ),
        ),
        color: Colors.transparent,
      ),
    );
  }
}
