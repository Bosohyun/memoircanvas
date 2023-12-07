import 'package:flutter/material.dart';

import 'package:memoircanvas/core/extensions/context_extension.dart';

class NestedBackButton extends StatelessWidget {
  const NestedBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          try {
            context.pop();
            return false;
          } catch (_) {
            return true;
          }
        },
        child: IconButton(
          onPressed: () {
            try {
              context.pop();
            } catch (_) {
              Navigator.of(context).pop();
            }
          },
          icon: Theme.of(context).platform == TargetPlatform.iOS
              ? const Icon(Icons.arrow_back_ios)
              : const Icon(Icons.arrow_back),
        ));
  }
}
