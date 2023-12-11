import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class BestButton extends StatefulWidget {
  const BestButton({required this.text, this.onPressed, super.key});

  final String text;
  final Function()? onPressed;

  @override
  State<BestButton> createState() => _BestButtonState();
}

enum ButtonState { init, loading, done }

class _BestButtonState extends State<BestButton> {
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
            side: const BorderSide(
              width: 2,
              color: Colors.indigo,
            ),
            backgroundColor: Colors.indigo),
        onPressed: () async {
          if (!mounted) return;
          setState(() => state = ButtonState.loading);
          await widget.onPressed!();

          if (!mounted) return;
          setState(() => state = ButtonState.done);
          await Future.delayed(Duration(seconds: 2));

          if (!mounted) return;
          setState(() => state = ButtonState.init);
        },
        child: AutoSizeText(
          widget.text,
          style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
              letterSpacing: 1.5,
              fontWeight: FontWeight.w900),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      );

  Widget buildSmallButton(bool isDone) {
    final color = isDone ? Colors.green : Colors.indigo;
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
