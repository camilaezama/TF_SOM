import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexagon/hexagon.dart';


Widget _buildMore(Size size) {
    var padding = 8.0;
    var w = (size.width - 4 * padding) / 2;
    var h = 150.0;
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.all(padding),
                child: HexagonWidget.flat(
                  width: w,
                  child: AspectRatio(
                    aspectRatio: HexagonType.FLAT.ratio,
                    child: Image.asset(
                      'assets/bee.jpg',
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(padding),
                child: HexagonWidget.pointy(
                  width: w,
                  child: AspectRatio(
                    aspectRatio: HexagonType.POINTY.ratio,
                    child: Image.asset(
                      'assets/tram.jpg',
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: HexagonWidget.flat(
                  height: h,
                  color: Colors.orangeAccent,
                  child: Text('flat\nheight: ${h.toStringAsFixed(2)}'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: HexagonWidget.pointy(
                  height: h,
                  color: Colors.red,
                  child: Text('pointy\nheight: ${h.toStringAsFixed(2)}'),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(padding),
            child: HexagonWidget.flat(
              width: w,
              color: Colors.limeAccent,
              elevation: 0,
              child: Text('flat\nwidth: ${w.toStringAsFixed(2)}\nelevation: 0'),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(padding),
            child: HexagonWidget.pointy(
              width: w,
              color: Colors.lightBlue,
              child: Text('pointy\nwidth: ${w.toStringAsFixed(2)}'),
            ),
          ),
        ],
      ),
    );
  }



// Widget _buildSomGrid3() {
//     return Column(
//       children: [
//         Container(
//             height: 50.0,
//             decoration: BoxDecoration(
//                 gradient: gradiente)),
//         HexagonOffsetGrid.evenPointy(
//           //color: Colors.yellow.shade100,
//           padding: const EdgeInsets.only(
//               left: 150.0, top: 50.0, bottom: 50.0, right: 150.0),
//           columns: 24,
//           rows: 14,
//           buildTile: (col, row) {
//             if (dataMap.isNotEmpty) {
//               int BMU = row * 24 + col + 1;
//               String valorDist = dataMap[BMU.toString()]!;
//               String valorDistConPunto = valorDist.replaceAll(',', '.');
//               double valor = double.parse(valorDistConPunto);
//               return HexagonWidgetBuilder(
//                 color: getInterpolatedColor(valor),
//                 //color: getColorForValue(valor),
//                 //generarColorAleatorioEnEspectro(), //row.isEven ? Colors.yellow : Colors.orangeAccent,
//                 elevation: 0.0,
//                 padding: 0.6,
//               );
//             } else {
//               return HexagonWidgetBuilder(
//                 color: Colors.white,
//                 //generarColorAleatorioEnEspectro(), //row.isEven ? Colors.yellow : Colors.orangeAccent,
//                 elevation: 0.0,
//                 padding: 0.6,
//               );
//             }
//           },
//           buildChild: (col, row) => ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.transparent, // Fondo transparente
//                 //onPrimary: Colors.blue, // Color del texto cuando se presiona
//                 elevation: 0, // Elimina la sombra del botón
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8.0),
//                   //side: BorderSide(color: Colors.blue), // Borde del color deseado
//                 ),
//               ),
//               onPressed: () {
//                 //loadData();
//                 showDialog<void>(
//                   context: context,
//                   builder: (BuildContext context) {
//                     int bMU = row * 24 + col + 1;
//                     String valorDist = dataMap[bMU.toString()]!;

//                     return AlertDialog(
//                       title: const Text('Información'),
//                       content: SingleChildScrollView(
//                         child: ListBody(
//                           children: [
//                             const Text(
//                                 'Este es un cuadro de diálogo de ejemplo.'),
//                             Text('BMU = $bMU'),
//                             Text('Udist = $valorDist'),
//                           ],
//                         ),
//                       ),
//                       actions: [
//                         TextButton(
//                           onPressed: () {
//                             Navigator.of(context)
//                                 .pop(); // Cerrar el cuadro de diálogo
//                           },
//                           child: Text('Cerrar'),
//                         ),
//                       ],
//                     );
//                   },
//                 );
//               },
//               child: Text('$col, $row')),
//         ),
//       ],
//     );
//   }



  // Color getInterpolatedColor(double value) {
  //   Map<String, double> doubleMap = convertToDouble(dataMap);
  //   final double min = doubleMap.values
  //       .reduce((value, element) => value < element ? value : element);
  //   final double max = doubleMap.values
  //       .reduce((value, element) => value > element ? value : element);

  //   // const Gradient gradient = LinearGradient(
  //   //   colors: [
  //   //     Colors.blue,
  //   //     Colors.green,
  //   //     Colors.yellow,
  //   //     Colors.red,
  //   //   ],
  //   //   stops: [0.0, 0.3, 0.6, 1.0],
  //   // );

  //   Gradient gradient = gradiente;

  //   if (value <= min) {
  //     return gradient.colors.first;
  //   } else if (value >= max) {
  //     return gradient.colors.last;
  //   } else {
  //     final double normalizedValue = (value - min) / (max - min);
  //     final List<Color> gradientColors = gradient.colors;
  //     final List<double>? stops = gradient.stops;

  //     int index = 0;
  //     while (index < stops!.length - 1 && normalizedValue > stops[index + 1]) {
  //       index++;
  //     }

  //     final double t =
  //         (normalizedValue - stops[index]) / (stops[index + 1] - stops[index]);

  //     return Color.lerp(gradientColors[index], gradientColors[index + 1], t)!;
  //   }
  // }








    // Función para asignar colores en el gradiente
  // Color getColorForValue(double value) {
  //   Map<String, double> doubleMap = convertToDouble(dataMap);

  //   final double min = doubleMap.values
  //       .reduce((value, element) => value < element ? value : element);
  //   final double max = doubleMap.values
  //       .reduce((value, element) => value > element ? value : element);

  //   // const Gradient gradient = LinearGradient(
  //   //   colors: [Colors.blue, Colors.red], // Reemplaza con los colores que desees
  //   //   stops: [0.0, 1.0],
  //   // );

  //   const Gradient gradient = LinearGradient(
  //     colors: [
  //       Colors.blue,
  //       Colors.green,
  //       Colors.yellow,
  //       Colors.red,
  //     ],
  //     stops: [0.0, 0.3, 0.6, 1.0],
  //   );

  //   final double normalizedValue = (value - min) / (max - min);
  //   final Color? color =
  //       ColorTween(begin: gradient.colors[0], end: gradient.colors[3])
  //           .lerp(normalizedValue);

  //   return color!;
  // }





  //   Map<String, double> convertToDouble(Map<String, String> inputMap) {
  //   Map<String, double> result = {};

  //   inputMap.forEach((key, value) {
  //     // Reemplaza la coma por un punto y luego convierte a double
  //     double doubleValue = double.parse(value.replaceAll(',', '.'));
  //     result[key] = doubleValue;
  //   });

  //   return result;
  // }



    // Scrollbar(
  //             controller: _vertical,
  //             thumbVisibility: true,
  //             trackVisibility: true,
  //             child: Scrollbar(
  //               controller: _horizontal,
  //               thumbVisibility: true,
  //               trackVisibility: true,
  //               notificationPredicate: (notif) => notif.depth == 1,
  //               child: SingleChildScrollView(
  //                 controller: _vertical,
  //                 child: SingleChildScrollView(
  //                   controller: _horizontal,
  //                   scrollDirection: Axis.horizontal,
  //                   child: DataTable(
  //                     columns: List.generate(
  //                       columnNames!.length,
  //                       (index) => DataColumn(label: Text(columnNames![index])),
  //                     ),
  //                     rows: List.generate(
  //                       csvData.length - 1,
  //                       (rowIndex) => DataRow(
  //                         cells: List.generate(
  //                           columnNames!.length,
  //                           (cellIndex) {
  //                             String filaCompleta =
  //                                 csvData[rowIndex + 1].toString();
  //                             String filaSinCorchetes =
  //                                 filaCompleta.replaceAll(RegExp(r'\[|\]'), '');
  //                             List<String> lista = filaSinCorchetes.split(';');
  //                             if (lista.length <= cellIndex) {
  //                               print(
  //                                   'Error: No hay suficientes elementos en la fila $rowIndex');
  //                               return DataCell(Text('Error'));
  //                             }
  //                             return DataCell(
  //                               Text('${lista[cellIndex]}'),
  //                             );
  //                           },
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           )




  // Expanded(
  //         child: SingleChildScrollView(
  //           scrollDirection: Axis.vertical,
  //           child: DataTable(
  //             columns: List.generate(
  //               columnNames!.length,
  //               (index) => DataColumn(label: Text(columnNames![index])),
  //             ),
  //             rows: List.generate(
  //               csvData.length - 1,
  //               (rowIndex) => DataRow(
  //                 cells: List.generate(
  //                   columnNames!.length,
  //                   (cellIndex) {
  //                     String filaCompleta = csvData[rowIndex + 1].toString();
  //                     String filaSinCorchetes = filaCompleta.replaceAll(RegExp(r'\[|\]'), '');
  //                     List<String> lista = filaSinCorchetes.split(';');
  //                     if (lista.length <= cellIndex) {
  //                       print(
  //                           'Error: No hay suficientes elementos en la fila $rowIndex');
  //                       return DataCell(Text('Error'));
  //                     }
  //                     return DataCell(
  //                       Text('${lista[cellIndex]}'),
  //                     );
  //                   },

  //                 ),
  //               ),
  //             ),
  //           ),
  //         ),
  //       )

  // (cellIndex) => DataCell(
  //   Text('${csvData[rowIndex + 1][cellIndex]}'),
  //   // Text(
  //   //   // '${csvData[rowIndex + 1][0].toString().split(';')[cellIndex]}'),
  //   //     // '${csvData[rowIndex + 1][0].toString().split(';')[cellIndex]}'),
  // ),

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: const Text('Home Page'),
  //     ),
  //     body: Center(
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: <Widget>[
  //           const Text(
  //             'Contenido de la página principal',
  //             style: TextStyle(fontSize: 18.0),
  //           ),
  //           const SizedBox(height: 20.0),
  //           ElevatedButton(
  //             onPressed: () {
  //               Navigator.pushNamed(context, '/grillas');
  //             },
  //             child: const Text('Ir a la Segunda Página'),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }