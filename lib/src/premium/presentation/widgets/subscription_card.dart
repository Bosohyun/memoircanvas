import 'package:flutter/material.dart';

class SubscriptionCard extends StatelessWidget {
  const SubscriptionCard(
      {required this.title,
      required this.onPressed,
      required this.price,
      required this.desc1,
      required this.desc2,
      required this.desc3,
      required this.fowardgroundColor,
      required this.backgroundColor,
      required this.buttonColor,
      required this.buttonTextColor,
      required this.subscriptionActive,
      super.key});

  final String title;
  final String price;
  final String desc1;
  final String desc2;
  final String desc3;
  final bool subscriptionActive;
  final Color fowardgroundColor;
  final Color backgroundColor;
  final Color buttonColor;
  final Color buttonTextColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(
          10,
        ),
        //shadow
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: SizedBox(
        width: 330.0,
        height: 290.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 10,
            ),
            Text(
              title,
              style: TextStyle(
                color: fowardgroundColor,
                fontSize: 20.0,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              price,
              style: TextStyle(
                  color: fowardgroundColor,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              desc1,
              style: TextStyle(
                color: fowardgroundColor,
                fontSize: 15.0,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              desc2,
              style: TextStyle(
                color: fowardgroundColor,
                fontSize: 12.0,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: buttonTextColor,
                backgroundColor: buttonColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onPressed: onPressed,
              child: subscriptionActive
                  ? const Text(
                      'Manage Subscription',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : const Text(
                      'Choose Plan',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              desc3,
              style: TextStyle(
                  color: fowardgroundColor,
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
