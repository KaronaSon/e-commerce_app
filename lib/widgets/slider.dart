import 'package:carousel_slider/carousel_slider.dart';
import 'package:ecommerc_app/data/slide.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SliderBanner extends StatefulWidget {
  const SliderBanner({super.key});

  @override
  State<SliderBanner> createState() => _SliderBannerState();
}

class _SliderBannerState extends State<SliderBanner> {
  int current = 0;
  final CarouselSliderController controller = CarouselSliderController();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 16,
      ),
      height: MediaQuery.of(context).size.height * 0.25,
      child: Column(
        children: [
          CarouselSlider(
            items: slidesCarousel.map(
              (slide) {
                return Bounceable(
                  scaleFactor: 0.5,
                  onTap: () {},
                  child: Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image: NetworkImage(
                          slide,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Image(
                      loadingBuilder: _buildLoadingShimmer,
                      image: NetworkImage(slide),
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ).toList(),
            carouselController: controller,
            options: CarouselOptions(
              autoPlay: true,
              autoPlayCurve: Curves.easeInQuad,
              enlargeCenterPage: true,
              aspectRatio: 2.5,
              onPageChanged: (index, reason) {
                setState(() {
                  current = index;
                });
              },
            ),
          ),
          const Spacer(),
          AnimatedSmoothIndicator(
            activeIndex: current,
            count: 6,
            effect: ExpandingDotsEffect(
              dotColor: Colors.grey[300]!,
              dotHeight: 10,
              dotWidth: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingShimmer(
      BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
    if (loadingProgress == null) return child;
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
