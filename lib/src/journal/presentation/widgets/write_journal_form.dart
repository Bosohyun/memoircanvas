import 'package:flutter/material.dart';
import 'package:memoircanvas/core/common/widgets/i_field.dart';

import 'package:memoircanvas/core/extensions/context_extension.dart';

class WriteJournalForm extends StatefulWidget {
  const WriteJournalForm({
    required this.titleController,
    required this.journalController,
    required this.focusNode,
    required this.formKey,
    super.key,
  });

  final TextEditingController titleController;
  final FocusNode focusNode;

  final TextEditingController journalController;
  final GlobalKey<FormState> formKey;

  @override
  State<WriteJournalForm> createState() => _WriteJournalFormState();
}

class _WriteJournalFormState extends State<WriteJournalForm> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          IField(
            controller: widget.journalController,
            hintText: 'How\'s your day?',
            minLine: 10,
            maxLine: 15,
            borderRadious: 20,
            contentVerticalPadding: 20,
          ),
          SizedBox(height: context.height * 0.05),
        ],
      ),
    );
  }
}
