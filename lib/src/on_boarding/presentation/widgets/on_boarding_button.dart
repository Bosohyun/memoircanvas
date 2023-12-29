import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:memoircanvas/core/extensions/context_extension.dart';

class OnBoardinigButton extends StatefulWidget {
  const OnBoardinigButton({
    required this.text,
    this.onPressed,
    super.key,
  });

  final String text;
  final Function()? onPressed;

  @override
  State<OnBoardinigButton> createState() => _OnBoardinigButtonState();
}

enum ButtonState { init, loading, done }

class _OnBoardinigButtonState extends State<OnBoardinigButton> {
  bool isAnimating = true;

  ButtonState state = ButtonState.init;
  @override
  Widget build(BuildContext context) {
    bool isStretched = isAnimating || state == ButtonState.init;
    bool isDone = state == ButtonState.done;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeIn,
      width: state == ButtonState.init ? 200 : 70,
      onEnd: () => setState(() => isAnimating = !isAnimating),
      child: SizedBox(
        width: 200,
        height: 55,
        child: isStretched ? buildButton() : buildSmallButton(isDone),
      ),
    );
  }

  Widget buildButton() => OutlinedButton(
        style: OutlinedButton.styleFrom(
            shape: const StadiumBorder(),
            side: BorderSide(
              width: 2,
              color: context.theme.colorScheme.primary,
            ),
            backgroundColor: context.theme.colorScheme.primary),
        onPressed: () async {
          if (!mounted) return;
          setState(() => state = ButtonState.loading);
          await Future.delayed(const Duration(milliseconds: 1500));

          if (!mounted) return;
          setState(() => state = ButtonState.done);
          await Future.delayed(const Duration(milliseconds: 1000));
          await widget.onPressed!();

          if (!mounted) return;
          setState(() => state = ButtonState.init);
        },
        child: AutoSizeText(
          widget.text,
          style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
              letterSpacing: 1.5,
              fontWeight: FontWeight.w900),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      );

  Widget buildSmallButton(bool isDone) {
    final color = isDone ? Colors.green : context.theme.colorScheme.primary;
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
      child: Center(
        child: isDone
            ? const Icon(
                Icons.done,
                size: 40,
                color: Colors.white,
              )
            : const CircularProgressIndicator(
                color: Colors.white,
              ),
      ),
    );
  }
}
