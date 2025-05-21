import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:wow/app/core/extensions.dart';

class ProfileDetailsShimmer extends StatelessWidget {
  const ProfileDetailsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // Top shimmer image (as flexible space)
        SliverAppBar(
          expandedHeight: context.height * .45,
          pinned: true,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          flexibleSpace: Container(
            width: double.infinity,
            height: context.height * .45,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(20),
            ),
          ).animate(onPlay: (controller) => controller.repeat())
           .shimmer(duration: 1500.ms, color: Colors.white),
        ),

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Simulated tab bar shimmer
                Row(
                  children: List.generate(3, (index) {
                    return Container(
                      width: 100,
                      height: 28,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ).animate(delay: (index * 100).ms)
                     .shimmer(duration: 1500.ms);
                  }),
                ),
                const SizedBox(height: 24),

                // Simulated detail rows shimmer
                Column(
                  children: List.generate(6, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: [
                          Container(
                            width: 100,
                            height: 16,
                            color: Colors.grey.shade300,
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Container(
                              height: 16,
                              color: Colors.grey.shade300,
                            ),
                          )
                        ],
                      ).animate(delay: (index * 120).ms)
                       .shimmer(duration: 1500.ms),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
