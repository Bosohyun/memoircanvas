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
          title: 'Welcome to MemoirCanvas',
          description: 'A place to store your memories and thoughts',
        );

  @override
  List<Object?> get props => [image, title, description];
}
