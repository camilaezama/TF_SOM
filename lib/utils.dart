import 'dart:ui';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Color getInterpolatedColor(
    double value, Gradient? gradiente, Map<String, String>? dataMap) {
  Map<String, double> doubleMap = convertToDouble(dataMap!);
  final double min = doubleMap.values
      .reduce((value, element) => value < element ? value : element);
  final double max = doubleMap.values
      .reduce((value, element) => value > element ? value : element);

  // const Gradient gradient = LinearGradient(
  //   colors: [
  //     Colors.blue,
  //     Colors.green,
  //     Colors.yellow,
  //     Colors.red,
  //   ],
  //   stops: [0.0, 0.3, 0.6, 1.0],
  // );

  Gradient gradient = gradiente!;

  if (value <= min) {
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



Future<Map<String, String>> loadData(String archivoCsv, int columnaNumeroNeuronas, int columnaValores) async {    
    Map<String, String> dataMap = {};

    ByteData data = await rootBundle.load(archivoCsv);
    String content = String.fromCharCodes(data.buffer.asUint8List());

    // Parsear el contenido CSV con el delimitador ';'
    List<List<dynamic>> rows =
        const CsvToListConverter(eol: '\n', fieldDelimiter: ';')
            .convert(content);

    if (rows.isNotEmpty) {
      rows.removeAt(0);
    }

    for (var row in rows) {
      String bmu =
          row[columnaNumeroNeuronas]?.toString() ?? ''; // Assuming 'BMU' is in the first column
      String valor =
          row[columnaValores]?.toString() ?? ''; // Assuming 'Udist' is in the second column
      dataMap[bmu] = valor;
    }

    // setState(() {
    //     //cargo = true;
    // });

    return dataMap;
  }
