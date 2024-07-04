import 'package:TF_SOM_UNMdP/presentacion/shared-widgets/grilla_hexagonos.dart';
import 'package:flutter/material.dart';

class HitDialog extends StatefulWidget {
  final int bmu;
  final List<String> etiquetas;
  final List<Color> colores;
  final Table tablaDatos;
  final String selectedKey;

  const HitDialog(
      {super.key,
      required this.bmu,
      required this.etiquetas,
      required this.colores,
      required this.tablaDatos,
      required this.selectedKey});

  @override
  State<HitDialog> createState() => _HitDialogState();
}

class _HitDialogState extends State<HitDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Hit'),
      content: SizedBox(
        width: MediaQuery.of(context).size.width / 2,
        child: Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width / 4,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                        alignment: Alignment.topLeft,
                        child: Text('BMU = ${widget.bmu}')),
                    const SizedBox(height: 15),
                    Align(
                        alignment: Alignment.topLeft,
                        child: Text('Etiquetas: ${widget.selectedKey}',
                            style:
                                const TextStyle(fontWeight: FontWeight.bold))),
                    const SizedBox(height: 15),
                    SizedBox(
                      width: 100,
                      height: 100,
                      child: CustomPaint(
                        size: const Size(100, 100), // Tamaño del círculo
                        painter: MultipleCirclePainter(widget.colores),
                      ),
                    ),
                    const SizedBox(height: 15),
                    ..._buildEtiquetasWidgets(widget.etiquetas, widget.colores),
                    Text('Total de datos: ${widget.etiquetas.length}'),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 500.0,
              width: MediaQuery.of(context).size.width / 4,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Text(
                      "Codebook",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Color.fromARGB(255, 52, 56, 253),
                          fontSize: 30.0),
                    ),
                    widget.tablaDatos
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Cerrar el cuadro de diálogo
          },
          child: const Text('Cerrar'),
        ),
      ],
    );
  }
}

List<Widget> _buildEtiquetasWidgets(
    List<String> etiquetas, List<Color> colores) {
  // Contamos  frecuencia de cada etiqueta
  Map<String, int> frecuencia = {};
  for (var etiqueta in etiquetas) {
    if (frecuencia.containsKey(etiqueta)) {
      frecuencia[etiqueta] = frecuencia[etiqueta]! + 1;
    } else {
      frecuencia[etiqueta] = 1;
    }
  }
  int total = etiquetas.length;

  // Crea la lista de widgets
  List<Widget> widgets = [];
  frecuencia.forEach((etiqueta, count) {
    int index = etiquetas.indexOf(etiqueta);
    Color color = colores[index];
    double porcentaje = (count / total) * 100;
    widgets.add(
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Card(
          elevation: 4,
          margin: const EdgeInsets.symmetric(vertical: 5.0),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 15.0),
            leading: Container(
              width: 30,
              height: 30,
              color: color,
            ),
            subtitle: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  etiqueta,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Cantidad: $count',
                  style: const TextStyle(fontSize: 12),
                ),
                Text(
                  'Porcentaje: ${porcentaje.toStringAsFixed(2)}%',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  });

  return widgets;
}










// Widget dialogBotonHits(BuildContext context, int bmu, String valorDist) {
//     bool tieneEtiquetas = mapaBMUconEtiquetas!.containsKey(bmu);

//     if (!tieneEtiquetas) {
//       return dialogBotonBMUS(context, bmu, valorDist);
//     } else {
//       final etiquetas = mapaBMUconEtiquetas![bmu]![selectedKey];
//       final List<Color> colores =
//           etiquetas!.map((etiqueta) => mapaColores![etiqueta]!).toList();
//       return AlertDialog(
//         title: const Text('Hit'),
//         content: SizedBox(
//           width: MediaQuery.of(context).size.width / 2,
//           child: Row(
//             children: [
//               SizedBox(
//                 width: MediaQuery.of(context).size.width / 4,
//                 child: SingleChildScrollView(
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Align(
//                           alignment: Alignment.topLeft,
//                           child: Text('BMU = $bmu')),
//                       const SizedBox(height: 15),
//                       SizedBox(
//                         width: 100,
//                         height: 100,
//                         child: CustomPaint(
//                           size: const Size(100, 100), // Tamaño del círculo
//                           painter: MultipleCirclePainter(colores),
//                         ),
//                       ),
//                       const SizedBox(height: 15),
//                       ..._buildEtiquetasWidgets(etiquetas, colores),
//                       Text('Total de datos: ${etiquetas.length}'),
//                       const SizedBox(height: 20),
//                     ],
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 height: 500.0,
//                 width: MediaQuery.of(context).size.width / 4,
//                 child: SingleChildScrollView(
//                   child: Column(
//                     children: [
//                       const Text(
//                         "Codebook",
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                             color: Color.fromARGB(255, 52, 56, 253),
//                             fontSize: 30.0),
//                       ),
//                       Table(
//                         border: TableBorder.all(
//                             color: Colors.black,
//                             style: BorderStyle.solid,
//                             width: 1),
//                         children: crearTablaDatos(
//                             nombreColumnas, (codebook[bmu - 1]), titulo),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop(); // Cerrar el cuadro de diálogo
//             },
//             child: const Text('Cerrar'),
//           ),
//         ],
//       );
//     }
//   }

  /// Todo en una columna
  // Widget dialogBotonHits(BuildContext context, int bmu, String valorDist) {
  //   bool tieneEtiquetas = mapaBMUconEtiquetas!.containsKey(bmu);

  //   if (!tieneEtiquetas) {
  //     return dialogBotonBMUS(context, bmu, valorDist);
  //   } else {
  //     final etiquetas = mapaBMUconEtiquetas![bmu]![selectedKey];
  //     final List<Color> colores =
  //         etiquetas!.map((etiqueta) => mapaColores![etiqueta]!).toList();
  //     return AlertDialog(
  //       title: const Text('Hit'),
  //       content: SizedBox(
  //         width: MediaQuery.of(context).size.width / 3,
  //         child: SingleChildScrollView(
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               Align(alignment: Alignment.topLeft, child: Text('BMU = $bmu')),
  //               const SizedBox(height: 15),
  //               SizedBox(
  //                 width: 100,
  //                 height: 100,
  //                 child: CustomPaint(
  //                   size: const Size(100, 100), // Tamaño del círculo
  //                   painter: MultipleCirclePainter(colores),
  //                 ),
  //               ),
  //               const SizedBox(height: 15),
  //               ..._buildEtiquetasWidgets(etiquetas, colores),
  //               Text('Total de datos: ${etiquetas.length}'),
  //               const SizedBox(height: 20),
  //               const Text(
  //                 "Codebook",
  //                 textAlign: TextAlign.center,
  //                 style: TextStyle(
  //                     color: Color.fromARGB(255, 52, 56, 253), fontSize: 30.0),
  //               ),
  //               Table(
  //                 border: TableBorder.all(
  //                     color: Colors.black, style: BorderStyle.solid, width: 1),
  //                 children: crearTablaDatos(
  //                     nombreColumnas, (codebook[bmu - 1]), titulo),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //       actions: [
  //         TextButton(
  //           onPressed: () {
  //             Navigator.of(context).pop(); // Cerrar el cuadro de diálogo
  //           },
  //           child: const Text('Cerrar'),
  //         ),
  //       ],
  //     );
  //   }
  // }