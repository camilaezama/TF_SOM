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
      Color.fromARGB(255, 167, 237, 255),
      Color.fromARGB(255, 84, 196, 250),
      Color.fromARGB(255, 107, 179, 248),
      Color.fromARGB(255, 158, 141, 245),
      Color.fromARGB(255, 218, 96, 241),
      Color.fromARGB(255,255,0,237),
    ],
    stops: [0.0, 0.2, 0.4, 0.6, 0.8, 1.0],
  ),
];