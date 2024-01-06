import 'package:flutter/material.dart';
import 'package:memoircanvas/core/common/widgets/i_field.dart';
import 'package:memoircanvas/src/journal/presentation/utils/weather.dart';

import 'package:weather_icons/weather_icons.dart';

import 'package:memoircanvas/core/extensions/context_extension.dart';

class WriteGenJournalForm extends StatefulWidget {
  const WriteGenJournalForm({
    required this.titleController,
    required this.weatherController,
    required this.journalController,
    required this.focusNode,
    required this.formKey,
    super.key,
  });

  final TextEditingController weatherController;
  final TextEditingController titleController;
  final FocusNode focusNode;

  final TextEditingController journalController;
  final GlobalKey<FormState> formKey;

  @override
  State<WriteGenJournalForm> createState() => _WriteJournalFormState();
}

class _WriteJournalFormState extends State<WriteGenJournalForm> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          Text('Weather', style: context.theme.textTheme.displaySmall),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () {
                  widget.weatherController.text = Weather.sunny.toUpperCase();
                },
                icon: const Icon(
                  WeatherIcons.day_sunny,
                ),
                color: context.theme.colorScheme.primary,
              ),
              IconButton(
                onPressed: () {
                  widget.weatherController.text = Weather.cloudy.toUpperCase();
                },
                icon: const Icon(
                  WeatherIcons.cloudy,
                ),
                color: context.theme.colorScheme.primary,
              ),
              IconButton(
                onPressed: () {
                  widget.weatherController.text = Weather.windy.toUpperCase();
                },
                icon: const Icon(
                  WeatherIcons.strong_wind,
                ),
                color: context.theme.colorScheme.primary,
              ),
              IconButton(
                onPressed: () {
                  widget.weatherController.text = Weather.rainy.toUpperCase();
                },
                icon: const Icon(
                  WeatherIcons.rain,
                ),
                color: context.theme.colorScheme.primary,
              ),
              IconButton(
                onPressed: () {
                  widget.weatherController.text = Weather.snowy.toUpperCase();
                },
                icon: const Icon(
                  WeatherIcons.snow,
                ),
                color: context.theme.colorScheme.primary,
              ),
              IconButton(
                onPressed: () {
                  widget.weatherController.text = Weather.foggy.toUpperCase();
                },
                icon: const Icon(
                  WeatherIcons.fog,
                ),
                color: context.theme.colorScheme.primary,
              ),
              IconButton(
                onPressed: () {
                  widget.weatherController.text =
                      Weather.thunderstorm.toUpperCase();
                },
                icon: const Icon(
                  WeatherIcons.thunderstorm,
                ),
                color: context.theme.colorScheme.primary,
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          IField(
            controller: widget.weatherController,
            readOnly: true,
            textAlign: TextAlign.center,
            contentVerticalPadding: 0,
          ),
          const SizedBox(height: 20),
          Text('Title', style: context.theme.textTheme.displaySmall),
          const SizedBox(height: 10),
          IField(
            controller: widget.titleController,
            hintText: 'Give your day a title',
            borderRadious: 20,
            contentVerticalPadding: 10,
          ),
          const SizedBox(height: 20),
          Text('Content', style: context.theme.textTheme.displaySmall),
          const SizedBox(height: 20),
          IField(
            controller: widget.journalController,
            hintText: 'How\'s your day?',
            minLine: 10,
            maxLine: 15,
            borderRadious: 20,
            contentVerticalPadding: 20,
          ),
        ],
      ),
    );
  }
}
