import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:memoircanvas/core/extensions/context_extension.dart';
import 'package:memoircanvas/core/res/colors.dart';

class CoreUtils {
  const CoreUtils._();

  static void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colours.primaryColour,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.all(10),
        ),
      );
  }

  static void showLoadingDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  static Future<File?> pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      return File(image.path);
    }
    return null;
  }

  static void showCustomDialog(
    BuildContext context, {
    required String title,
    required String content,
    required String actionText,
    required double height,
    required Color buttonHighlightColor,
    required Color buttonTextColor,
    TextEditingController? controller,
    double width = 300,
    bool isCancelBtn = true,
    required Function() action,
  }) {
    showGeneralDialog(
      context: context,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) {
        return Center(
          child: Material(
            type: MaterialType.transparency,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(30)),
              height: height,
              width: width,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(left: 15, top: 15),
                      height: 45,
                      width: width,
                      decoration: BoxDecoration(
                          color: context.theme.colorScheme.primary,
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30))),
                      child: Text(title,
                          style: context.theme.textTheme.displaySmall
                              ?.copyWith(color: Colors.white, fontSize: 18)),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 15),
                      child: Text(
                        content,
                        style: context.theme.textTheme.displaySmall?.copyWith(
                            color: context.theme.colorScheme.onPrimary,
                            fontSize: 15),
                      ),
                    ),
                    //If there is a controller, show a text field

                    if (controller != null)
                      Container(
                        padding:
                            const EdgeInsets.only(left: 15, right: 15, top: 30),
                        child: TextField(
                          controller: controller,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintStyle: context.theme.textTheme.displaySmall
                                ?.copyWith(color: Colors.grey, fontSize: 15),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),

                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        isCancelBtn
                            ? TextButton(
                                onPressed: () {
                                  if (controller != null) controller.clear();
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  'Cancel',
                                  style: context.theme.textTheme.displaySmall
                                      ?.copyWith(fontSize: 15),
                                ))
                            : const SizedBox.shrink(),
                        TextButton(
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all<EdgeInsets>(
                                const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 3)),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            backgroundColor: MaterialStateProperty.all<Color>(
                              buttonHighlightColor,
                            ),
                          ),
                          onPressed: action,
                          child: Text(
                            actionText,
                            style: context.theme.textTheme.displaySmall
                                ?.copyWith(
                                    fontSize: 14, color: buttonTextColor),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        )
                      ],
                    ),
                  ]),
            ),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        Tween<Offset> tween;
        if (anim.status == AnimationStatus.reverse) {
          tween = Tween(begin: const Offset(-1, 0), end: Offset.zero);
        } else {
          tween = Tween(begin: const Offset(1, 0), end: Offset.zero);
        }

        return SlideTransition(
          position: tween.animate(anim),
          child: FadeTransition(
            opacity: anim,
            child: child,
          ),
        );
      },
    );
  }
}
