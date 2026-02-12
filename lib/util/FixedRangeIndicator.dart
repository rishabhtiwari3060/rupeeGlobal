import 'package:flutter/material.dart';

import 'ColorConst.dart';
import 'Injection.dart';

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
                    gradient: LinearGradient(
                      colors: [DI<ColorConst>().redColor, DI<ColorConst>().dark_greenColor],
                    ),
                  ),
                ),

                // Fixed Pointer (NOT draggable)
                Positioned(
                  left: width * percent - 8,
                  top: -7,
                  child: Icon(
                    Icons.arrow_drop_down,
                    size: 20,
                    color: DI<ColorConst>().darkGryColor,
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
              style: TextStyle(color: DI<ColorConst>().redColor),
            ),
            Text(
              "High: ${max.toStringAsFixed(2)}",
              style: TextStyle(color: DI<ColorConst>().dark_greenColor),
            ),
          ],
        ),
      ],
    );
  }
}
