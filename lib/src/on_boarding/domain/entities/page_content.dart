import 'package:equatable/equatable.dart';
import 'package:memoircanvas/core/res/media_res.dart';

class PageContent extends Equatable {
  const PageContent({
    required this.image,
    required this.title,
    required this.description,
  });

  final String image;
  final String title;
  final String description;

  //TODO: Add more pages with example of journaling images

  const PageContent.first()
      : this(
          image: MediaRes.onBoardingFirstImage,
          title: 'Welcome to\nMemoir Canvas',
          description:
              "Transform your everyday stories into vivid visual memories.",
        );

  const PageContent.second()
      : this(
          image: MediaRes.onBoardingSecondImage,
          title: 'Welcome to\nMemoir Canvas',
          description:
              "Dive into a world where your emotions bloom into beautiful imagery.",
        );

  const PageContent.third()
      : this(
          image: MediaRes.onBoardingThirdImage,
          title: 'Welcome to\nMemoir Canvas',
          description:
              "Craft your narrative, then watch as we bring each page to life.",
        );
  @override
  List<Object?> get props => [image, title, description];
}
