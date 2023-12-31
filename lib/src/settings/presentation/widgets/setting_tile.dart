import 'package:flutter/material.dart';
import 'package:memoircanvas/core/extensions/context_extension.dart';

class SettingTile extends StatelessWidget {
  const SettingTile(
      {required this.leadingIcon,
      required this.title,
      required this.onTap,
      this.color = Colors.black,
      this.trailingIcon = const Icon(
        Icons.arrow_forward_ios,
        size: 13,
      ),
      super.key});

  final Icon leadingIcon;
  final String title;
  final Color color;
  final Icon? trailingIcon;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.theme.colorScheme.background,
      ),
      child: ListTile(
        leading: leadingIcon,
        title: Text(title,
            style: TextStyle(
              color: color,
            )),
        trailing: trailingIcon,
        onTap: onTap,
      ),
    );
  }
}
