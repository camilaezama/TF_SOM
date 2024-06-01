import 'package:flutter/material.dart';

Map<String, Color> generateColorMap(List<String> values) {
  final Map<String, Color> colorMap = {};
  for (int i = 0; i < values.length; i++) {
    colorMap[values[i]] = colores[i % colores.length];
  }
  return colorMap;
}

final List<Color> colores = [
  const Color(0xFF00FF00),
  const Color(0xFF0000FF),
  const Color(0xFFFF0000),
  const Color(0xFF01FFFE),
  const Color(0xFFFFA6FE),
  const Color(0xFFFFDB66),
  const Color(0xFF006401),
  const Color(0xFF010067),
  const Color(0xFF95003A),
  const Color(0xFF007DB5),
  const Color(0xFFFF00F6),
  const Color(0xFFFFEEE8),
  const Color(0xFF774D00),
  const Color(0xFF90FB92),
  const Color(0xFF0076FF),
  const Color(0xFFD5FF00),
  const Color(0xFFFF937E),
  const Color(0xFF6A826C),
  const Color(0xFFFF029D),
  const Color(0xFFFE8900),
  const Color(0xFF7A4782),
  const Color(0xFF7E2DD2),
  const Color(0xFF85A900),
  const Color(0xFFFF0056),
  const Color(0xFFA42400),
  const Color(0xFF00AE7E),
  const Color(0xFF683D3B),
  const Color(0xFFBDC6FF),
  const Color(0xFF263400),
  const Color(0xFFBDD393),
  const Color(0xFF00B917),
  const Color(0xFF9E008E),
  const Color(0xFF001544),
  const Color(0xFFC28C9F),
  const Color(0xFFFF74A3),
  const Color(0xFF01D0FF),
  const Color(0xFF004754),
  const Color(0xFFE56FFE),
  const Color(0xFF788231),
  const Color(0xFF0E4CA1),
];