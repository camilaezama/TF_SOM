import 'dart:ui';

import 'package:flutter/material.dart';

List<Gradient> listaGradientes = [
  const LinearGradient(
    begin: Alignment.topCenter, // comienza desde la parte superior
    end: Alignment.bottomCenter,
    colors: [
      Color.fromARGB(255, 8, 82, 143),
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.orange,
      Colors.red,
    ],
    stops: [0.0, 0.2, 0.4, 0.6, 0.8, 1.0],
  ),
  const LinearGradient(
    begin: Alignment.topCenter, // comienza desde la parte superior
    end: Alignment.bottomCenter,
    colors: [
      Color.fromARGB(255, 0, 0, 0),
      Color.fromARGB(255, 52, 52, 52),
      Color.fromARGB(255, 110, 110, 110),
      Color.fromARGB(255, 165, 165, 165),
      Color.fromARGB(255, 214, 214, 214),
      Color.fromARGB(255, 255, 255, 255),
    ],
    stops: [0.0, 0.2, 0.4, 0.6, 0.8, 1.0],
  ),
  const LinearGradient(
    begin: Alignment.topCenter, // comienza desde la parte superior
    end: Alignment.bottomCenter,
    colors: [
      Color.fromARGB(255, 255, 0, 0),
      Color.fromARGB(255, 255, 57, 57),
      Color.fromARGB(255, 255, 105, 105),
      Color.fromARGB(255, 255, 162, 162),
      Color.fromARGB(255, 255, 215, 215),
      Color.fromARGB(255, 255, 255, 255),
    ],
    stops: [0.0, 0.2, 0.4, 0.6, 0.8, 1.0],
  ),
  const LinearGradient(
    begin: Alignment.topCenter, // comienza desde la parte superior
    end: Alignment.bottomCenter,
    colors: [
      Color.fromARGB(255, 40, 40, 40),
      Color.fromARGB(255, 80, 80, 80),
      Color.fromARGB(255, 120, 120, 120),
      Color.fromARGB(255, 160, 160, 160),
      Color.fromARGB(255, 200, 200, 200),
      Color.fromARGB(255, 240, 240, 240),
    ],
    stops: [0.0, 0.2, 0.4, 0.6, 0.8, 1.0],
  ),
];
