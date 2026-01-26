import 'dart:math';
import 'package:flutter/material.dart';

final Random _random = Random();

Color getLightBrightColor() {
  return HSLColor.fromAHSL(
    1.0,
    _random.nextDouble() * 360, // hue
    0.5, // saturation (lower = softer)
    0.8, // lightness (higher = brighter)
  ).toColor();
}