import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kumuly_pocket/widgets/page_views/page_view_controller.dart';
import 'package:kumuly_pocket/widgets/page_views/page_view_indicator.dart';

class ImageCarousel extends ConsumerWidget {
  const ImageCarousel({
    super.key,
    required this.images,
    this.height = 360,
    this.width = 360,
  });

  final List<Image> images;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final carouselController = ref.watch(pageViewControllerProvider);

    return SizedBox(
      height: height,
      width: width,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView.builder(
            controller: carouselController.pageController,
            itemCount: images.length,
            pageSnapping: true,
            itemBuilder: (context, index) {
              return images[index];
            },
          ),
          Positioned(
            bottom: 16.0,
            child: PageViewIndicator(
              pageCount: images.length,
            ),
          ),
        ],
      ),
    );
  }
}
