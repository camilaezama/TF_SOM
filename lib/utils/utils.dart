import 'dart:ui';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Color getInterpolatedColor(
    double value, Gradient? gradiente, double min, double max) {
  Gradient gradient = gradiente!;
  if (value == -1) {
    return Colors.transparent;
  } else if (value <= min) {
    return gradient.colors.first;
  } else if (value >= max) {
    return gradient.colors.last;
  } else {
    final double normalizedValue = (value - min) / (max - min);
    final List<Color> gradientColors = gradient.colors;
    final List<double>? stops = gradient.stops;

    int index = 0;
    while (index < stops!.length - 1 && normalizedValue > stops[index + 1]) {
      index++;
    }

    final double t =
        (normalizedValue - stops[index]) / (stops[index + 1] - stops[index]);

    return Color.lerp(gradientColors[index], gradientColors[index + 1], t)!;
  }
}

Color getClusterColor(int col, int row, List<List<int>>? clusters) {
  if (clusters != null) {
    const List<Color> colores = [
      Color(0xFF00FF00),
      Color(0xFF0000FF),
      Color(0xFFFF0000),
      Color(0xFF01FFFE),
      Color(0xFFFFA6FE),
      Color(0xFFFFDB66),
      Color(0xFF006401),
      Color(0xFF010067),
      Color(0xFF95003A),
      Color(0xFF007DB5),
      Color(0xFFFF00F6),
      Color(0xFFFFEEE8),
      Color(0xFF774D00),
      Color(0xFF90FB92),
      Color(0xFF0076FF),
      Color(0xFFD5FF00),
      Color(0xFFFF937E),
      Color(0xFF6A826C),
      Color(0xFFFF029D),
      Color(0xFFFE8900),
      Color(0xFF7A4782),
      Color(0xFF7E2DD2),
      Color(0xFF85A900),
      Color(0xFFFF0056),
      Color(0xFFA42400),
      Color(0xFF00AE7E),
      Color(0xFF683D3B),
      Color(0xFFBDC6FF),
      Color(0xFF263400),
      Color(0xFFBDD393),
      Color(0xFF00B917),
      Color(0xFF9E008E),
      Color(0xFF001544),
      Color(0xFFC28C9F),
      Color(0xFFFF74A3),
      Color(0xFF01D0FF),
      Color(0xFF004754),
      Color(0xFFE56FFE),
      Color(0xFF788231),
      Color(0xFF0E4CA1),
      Color(0xFF91D0CB),
      Color(0xFFBE9970),
      Color(0xFF968AE8),
      Color(0xFFBB8800),
      Color(0xFF43002C),
      Color(0xFFDEFF74),
      Color(0xFF00FFC6),
      Color(0xFFFFE502),
      Color(0xFF620E00),
      Color(0xFF008F9C),
      Color(0xFF98FF52),
      Color(0xFF7544B1),
      Color(0xFFB500FF),
      Color(0xFF00FF78),
      Color(0xFFFF6E41),
      Color(0xFF005F39),
      Color(0xFF6B6882),
      Color(0xFF5FAD4E),
      Color(0xFFA75740),
      Color(0xFFA5FFD2),
      Color(0xFFFFB167),
      Color(0xFF009BFF),
      Color(0xFFE85EBE)
    ];
    int nroClusters = clusters[row][col];
    return colores[nroClusters];
  }

  return Color.fromARGB(0, 0, 0, 0);
}

Color getColorYaNorm(
    double value, Gradient? gradiente, Map<String, String>? dataMap) {
  Gradient gradient = gradiente!;

  final double normalizedValue = value;
  final List<Color> gradientColors = gradient.colors;
  final List<double>? stops = gradient.stops;

  int index = 0;
  while (index < stops!.length - 1 && normalizedValue > stops[index + 1]) {
    index++;
  }

  final double t =
      (normalizedValue - stops[index]) / (stops[index + 1] - stops[index]);

  return Color.lerp(gradientColors[index], gradientColors[index + 1], t)!;
}

Map<String, double> convertToDouble(Map<String, String> inputMap) {
  Map<String, double> result = {};

  inputMap.forEach((key, value) {
    // Reemplaza la coma por un punto y luego convierte a double
    double doubleValue = double.parse(value.replaceAll(',', '.'));
    result[key] = doubleValue;
  });

  return result;
}

Future<Map<String, String>> loadData(
    String archivoCsv, int columnaNumeroNeuronas, int columnaValores) async {
  Map<String, String> dataMap = {};

  ByteData data = await rootBundle.load(archivoCsv);
  String content = String.fromCharCodes(data.buffer.asUint8List());

  // Parsear el contenido CSV con el delimitador ';'
  List<List<dynamic>> rows =
      const CsvToListConverter(eol: '\n', fieldDelimiter: ';').convert(content);

  if (rows.isNotEmpty) {
    rows.removeAt(0);
  }

  for (var row in rows) {
    String bmu = row[columnaNumeroNeuronas]?.toString() ??
        ''; // Assuming 'BMU' is in the first column
    String valor = row[columnaValores]?.toString() ??
        ''; // Assuming 'Udist' is in the second column
    dataMap[bmu] = valor;
  }

  // setState(() {
  //     //cargo = true;
  // });

  return dataMap;
}

bool validarColumnasDatos(int f, int c, int cantDatos) {
  return (f * c == cantDatos);
}
