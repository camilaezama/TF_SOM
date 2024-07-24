import 'dart:ui';
import 'dart:math';
import 'package:flutter/material.dart';


/// Devuelve el color
// Color jetColormap(double value) {
//   double r = 0.0, g = 0.0, b = 0.0;

//   if (value <= 0.25) {
//     r = 0.0;
//     g = 4 * value;
//     b = 1.0;
//   } else if (value <= 0.5) {
//     r = 0.0;
//     g = 1.0;
//     b = 1 + 4 * (0.25 - value);
//   } else if (value <= 0.75) {
//     r = 4 * (value - 0.5);
//     g = 1.0;
//     b = 0.0;
//   } else {
//     r = 1.0;
//     g = 1 + 4 * (0.75 - value);
//     b = 0.0;
//   }

//   return Color.fromRGBO((r * 255).toInt(), (g * 255).toInt(), (b * 255).toInt(), 1.0);
// }

// /// Devuelve la matriz de colores
// List<List<Color>> generarMatrizJet(int rows, int cols) {
//   List<List<Color>> matrix = [];
//   for (int i = 0; i < rows; i++) {
//     List<Color> row = [];
//     for (int j = 0; j < cols; j++) {
//       double value = (i * cols + j) / (rows * cols - 1);
//       row.add(jetColormap(value));
//     }
//     matrix.add(row);
//   }
//   return matrix;
// }


/// otra opcion

List<List<Color>> generarMatrizJet(int rows, int cols) {
  List<List<Color>> matrix = [];
  for (int i = 0; i < rows; i++) {
    List<Color> row = [];
    for (int j = 0; j < cols; j++) {
      double value = ((i / (rows - 1)) + (j / (cols - 1))) / 2;
      row.add(jetColormap(value));
    }
    matrix.add(row);
  }
  return matrix;
}

Color jetColormap(double value) {
  double r = 0.0, g = 0.0, b = 0.0;

  if (value <= 0.25) {
    r = 0.0;
    g = 4 * value;
    b = 1.0;
  } else if (value <= 0.5) {
    r = 0.0;
    g = 1.0;
    b = 1 + 4 * (0.25 - value);
  } else if (value <= 0.75) {
    r = 4 * (value - 0.5);
    g = 1.0;
    b = 0.0;
  } else {
    r = 1.0;
    g = 1 + 4 * (0.75 - value);
    b = 0.0;
  }

  return Color.fromRGBO((r * 255).toInt(), (g * 255).toInt(), (b * 255).toInt(), 1.0);
}



/// Devuelve matriz en forma de mapa
Map<int, Color> devolverMapaBmuColor(int rows, int cols) {

  List<List<Color>> matrix = generarMatrizJet(rows,cols);
  Map<int, Color> colorMap = {};
  int index = 1;

  for (var row in matrix) {
    for (var color in row) {
      colorMap[index] = color;
      index++;
    }
  }

  return colorMap;
}

/// Clase para mostrar la grilla que se crea
/// Envolver en SizedBox con height y width
/// SizedBox(
///   height: 400.0,
///   width: 400.0,
///   child: ColorMatrixWidget(rows: 14, cols: 21)),
class ColorMatrixWidget extends StatelessWidget {
  final int rows;
  final int cols;

  ColorMatrixWidget({required this.rows, required this.cols});

  @override
  Widget build(BuildContext context) {
    //List<List<Color>> matrix = generarMatrizJet(rows, cols);
    List<List<Color>> matrix = somColorCode(generateCoordinates(rows, cols), rows, cols, colorCode: 'rgb1', scaling: true); 

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: cols,
      ),
      itemBuilder: (context, index) {
        int row = index ~/ cols;
        int col = index % cols;
        return Container(
          color: matrix[row][col],
          width: 20,
          height: 20,
        );
      },
      itemCount: rows * cols,
    );
  }
}








/// prueba 
/// 
List<List<double>> generateCoordinates(int rows, int cols) {
  List<List<double>> coordinates = [];
  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < cols; j++) {
      coordinates.add([i.toDouble(), j.toDouble()]);
    }
  }
  return coordinates;
}

Map<int, Color> matrixToMap(int rows, int cols) {

  List<List<Color>> colorMatrix  = somColorCode(generateCoordinates(rows, cols), rows, cols, colorCode: 'rgb1', scaling: true); 
  Map<int, Color> colorMap = {};
  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < cols; j++) {
      int linearIndex = i * cols + j + 1;
      colorMap[linearIndex] = colorMatrix[i][j];
    }
  }
  return colorMap;
}

List<List<Color>> somColorCode(List<List<double>> coordinates, int rows, int cols, {String colorCode = 'rgb1', bool scaling = true}) {
  int n = coordinates.length;
  List<List<double>> p = List.generate(n, (i) => [0.0, 0.0]);

  // Normalización de las coordenadas si el escalado está habilitado
  if (scaling) {
    double minX = coordinates.map((coord) => coord[0]).reduce(min);
    double minY = coordinates.map((coord) => coord[1]).reduce(min);
    double maxX = coordinates.map((coord) => coord[0]).reduce(max);
    double maxY = coordinates.map((coord) => coord[1]).reduce(max);

    for (int i = 0; i < n; i++) {
      p[i][0] = (coordinates[i][0] - minX) / (maxX - minX);
      p[i][1] = (coordinates[i][1] - minY) / (maxY - minY);
    }
  } else {
    p = coordinates;
  }

  // Inicializar la matriz de colores
  List<List<Color>> colorMatrix = List.generate(rows, (i) => List<Color>.filled(cols, Colors.white));

  // Asignación de colores según el esquema seleccionado
  for (int i = 0; i < n; i++) {
    double r, g, b;
    switch (colorCode) {
      case 'rgb1':
        r = p[i][0];
        g = 1 - p[i][1];
        b = p[i][1];
        break;
      case 'rgb2':
        r = p[i][0];
        g = 1 - p[i][1];
        b = 1 - p[i][0];
        break;
      case 'rgb3':
        r = p[i][0];
        g = 0.5;
        b = p[i][1];
        break;
      case 'hsv':
        double dx = 0.5 - p[i][0];
        double dy = 0.5 - p[i][1];
        double radius = sqrt(dx * dx + dy * dy);
        double angle = radius == 0 ? 0 : acos(dx / radius);
        if (dy < 0) angle = 2 * pi - angle;
        Color hsvColor = HSVColor.fromAHSV(1, angle * 180 / pi, 1, radius).toColor();
        r = hsvColor.red / 255.0;
        g = hsvColor.green / 255.0;
        b = hsvColor.blue / 255.0;
        break;
      default:
        r = p[i][0];
        g = 1 - p[i][1];
        b = p[i][1];
        break;
    }

    int row = i ~/ cols;
    int col = i % cols;
    colorMatrix[row][col] = Color.fromRGBO((r * 255).toInt(), (g * 255).toInt(), (b * 255).toInt(), 1.0);
  }

  return colorMatrix;
}