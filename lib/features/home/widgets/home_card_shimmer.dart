import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:wow/app/core/extensions.dart';
import 'package:wow/components/custom_network_image.dart';

class HomeCardShimmer extends StatelessWidget {
  const HomeCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: context.width,
          height: context.height,
          color: Colors.grey.shade300,
        ).animate().shimmer(duration: 1400.ms, color: Colors.white),
         Image.asset(
          "assets/images/imagebg.png",
          width: context.width,
          height: context.height,
          fit: BoxFit.cover,
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _shimmerLine(width: 200, height: 28),
              const SizedBox(height: 8),
              _shimmerLine(width: 120, height: 22),
              const SizedBox(height: 12),
              Row(
                children: [
                  _shimmerTag(),
                  _shimmerTag(),
                  _shimmerTag(),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(child: _shimmerButton(imageHeight: 70)),
                  const SizedBox(width: 10),
                  Expanded(child: _shimmerButton(imageHeight: 70)),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ],
    );
  }

  Widget _shimmerLine({required double width, required double height}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(8),
      ),
    ).animate().shimmer(duration: 1400.ms, color: Colors.white);
  }

  Widget _shimmerTag() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(18),
      ),
      child: const SizedBox(width: 60, height: 16),
    ).animate().shimmer(duration: 1400.ms, color: Colors.white);
  }

  Widget _shimmerButton({double imageHeight = 70}) {
    return Container(
      height: imageHeight,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(12),
      ),
    ).animate().shimmer(duration: 1400.ms, color: Colors.white);
  }
}
