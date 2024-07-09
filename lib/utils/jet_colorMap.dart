import 'package:flutter/material.dart';


/// Devuelve el color
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

/// Devuelve la matriz de colores
List<List<Color>> generarMatrizJet(int rows, int cols) {
  List<List<Color>> matrix = [];
  for (int i = 0; i < rows; i++) {
    List<Color> row = [];
    for (int j = 0; j < cols; j++) {
      double value = (i * cols + j) / (rows * cols - 1);
      row.add(jetColormap(value));
    }
    matrix.add(row);
  }
  return matrix;
}


/// otra opcion

// List<List<Color>> generarMatrizJet(int rows, int cols) {
//   List<List<Color>> matrix = [];
//   for (int i = 0; i < rows; i++) {
//     List<Color> row = [];
//     for (int j = 0; j < cols; j++) {
//       double value = ((i / (rows - 1)) + (j / (cols - 1))) / 2;
//       row.add(jetColormap(value));
//     }
//     matrix.add(row);
//   }
//   return matrix;
// }

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
    List<List<Color>> matrix = generarMatrizJet(rows, cols);

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