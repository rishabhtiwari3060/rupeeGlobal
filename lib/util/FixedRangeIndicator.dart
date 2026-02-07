import 'package:flutter/material.dart';

class FixedRangeIndicator extends StatelessWidget {
  final double min;
  final double max;
  final double value;

  const FixedRangeIndicator({
    super.key,
    required this.min,
    required this.max,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final percent = ((value - min) / (max - min)).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;

            return Stack(
              clipBehavior: Clip.none,
              children: [
                // Gradient Bar
                Container(
                  height: 8,
                  width: width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: const LinearGradient(
                      colors: [Colors.red, Colors.green],
                    ),
                  ),
                ),

                // Fixed Pointer (NOT draggable)
                Positioned(
                  left: width * percent - 8,
                  top: -7,
                  child: const Icon(
                    Icons.arrow_drop_down,
                    size: 20,
                    color: Colors.grey,
                  ),
                ),
              ],
            );
          },
        ),

        const SizedBox(height: 8),

        // Labels
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Low: ${min.toStringAsFixed(2)}",
              style: const TextStyle(color: Colors.red),
            ),
            Text(
              "High: ${max.toStringAsFixed(2)}",
              style: const TextStyle(color: Colors.green),
            ),
          ],
        ),
      ],
    );
  }
}
