// ignore: file_names
// ignore_for_file: file_names, duplicate_ignore

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CarouselImagesWidget extends StatelessWidget {
  final List<String> images;
  final int activeIndex;
  final Function(int) onPageChanged;
  final String productId;

  const CarouselImagesWidget({
    super.key,
    required this.images,
    required this.activeIndex,
    required this.onPageChanged,
    required this.productId,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CarouselSlider.builder(
          itemCount: images.length,
          itemBuilder: (context, index, realIndex) {
            final img = images[index];
            return Hero(
              tag: productId + index.toString(),
              child: Container(
                width: double.infinity,
                color: Colors.grey[800],
                child: InteractiveViewer(
                  panEnabled: true,
                  minScale: 1,
                  maxScale: 3,
                  child: Image.network(
                    img,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.orange),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Icon(Icons.error, color: Colors.red, size: 50),
                      );
                    },
                  ),
                ),
              ),
            );
          },
          options: CarouselOptions(
            height: 320,
            viewportFraction: 1.0,
            enableInfiniteScroll: false,
            enlargeCenterPage: false,
            onPageChanged: (index, reason) => onPageChanged(index),
          ),
        ),
        Positioned(
          bottom: 8,
          left: 0,
          right: 0,
          child: Center(
            child: AnimatedSmoothIndicator(
              activeIndex: activeIndex,
              count: images.length,
              effect: const WormEffect(
                dotWidth: 8,
                dotHeight: 8,
                activeDotColor: Colors.orange,
                dotColor: Colors.white24,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
