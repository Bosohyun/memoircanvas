import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:memoircanvas/core/common/widgets/i_field.dart';
import 'package:memoircanvas/core/extensions/context_extension.dart';
import 'package:memoircanvas/src/journal/presentation/utils/weather.dart';
import 'package:weather_icons/weather_icons.dart';

class WritePickJournalForm extends StatefulWidget {
  const WritePickJournalForm({
    required this.titleController,
    required this.weatherController,
    required this.journalController,
    required this.focusNode,
    required this.formKey,
    required this.onClickPickImage,
    required this.pickedImage,
    super.key,
  });

  final TextEditingController weatherController;
  final TextEditingController titleController;
  final FocusNode focusNode;
  final TextEditingController journalController;
  final GlobalKey<FormState> formKey;
  final Function({required bool isGallery}) onClickPickImage;
  final XFile? pickedImage;

  @override
  State<WritePickJournalForm> createState() => _WritePickJournalFormState();
}

class _WritePickJournalFormState extends State<WritePickJournalForm> {
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
          Text('Image', style: context.theme.textTheme.displaySmall),
          const SizedBox(height: 20),

          Container(
            height: context.width * 0.7,
            width: context.width * 0.7,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(0),
              border: Border.all(
                color: context.theme.colorScheme.primary,
                width: 2,
              ),
            ),
            child: (widget.pickedImage != null)
                ? Stack(
                    fit: StackFit.expand,
                    children: [
                      Image(
                        fit: BoxFit.cover,
                        image: FileImage(
                          File(widget.pickedImage!.path),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.photo_library_outlined),
                              onPressed: () async => await widget
                                  .onClickPickImage(isGallery: true),
                            ),
                            IconButton(
                              icon: const Icon(Icons.camera_alt_outlined),
                              onPressed: () async => await widget
                                  .onClickPickImage(isGallery: false),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.photo_library_outlined),
                        onPressed: () async =>
                            await widget.onClickPickImage(isGallery: true),
                      ),
                      IconButton(
                        icon: const Icon(Icons.camera_alt_outlined),
                        onPressed: () async =>
                            await widget.onClickPickImage(isGallery: false),
                      ),
                    ],
                  ),
          ),

          // (widget.pickedImage != null)
          //     ? Image(
          //         image: FileImage(File(widget.pickedImage!.path)),
          //       )
          //     : IconButton(
          //         iconSize: 40,
          //         icon: Icon(Icons.upload_outlined),
          //         onPressed: widget.onClickPickImage,
          //       ),
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
          SizedBox(height: context.height * 0.05),
        ],
      ),
    );
  }
}
