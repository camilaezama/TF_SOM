import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_application_1/utils.dart';
import 'package:hexagon/hexagon.dart';
import 'dart:typed_data';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

class GrillaHexagonos extends StatefulWidget {
  final Gradient? gradiente;
  final Map<String, String>? dataMap;
  final int filas;
  final int columnas;
  double paddingEntreHexagonos;
  GrillaHexagonos(
      {super.key,
      this.gradiente,
      this.dataMap,
      required this.filas,
      required this.columnas,
      this.paddingEntreHexagonos = 0.6});

  @override
  State<GrillaHexagonos> createState() => _GrillaHexagonosState();
}

class _GrillaHexagonosState extends State<GrillaHexagonos> {
  final _widgetKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: _widgetKey,
      child: Row(
        children: [
          ElevatedButton(onPressed: save, child: const Icon(Icons.download)),
          Container(
            width: 100.0, // ajusta la altura según tus necesidades
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter, // comienza desde la parte superior
                end: Alignment.bottomCenter, // termina en la parte inferior
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
            ),
          ),
          // Container(
          //     height: 50.0,
          //     decoration: BoxDecoration(gradient: widget.gradiente)),
          Padding(
            padding: const EdgeInsets.all(40.0),
            child: InteractiveViewer(
              child: HexagonOffsetGrid.oddPointy(
                  //color: Colors.yellow.shade100,
                  // padding: const EdgeInsets.only(
                  //     left: 50.0, top: 50.0, bottom: 10.0, right: 100.0),
                  columns: widget.columnas,
                  rows: widget.filas,
                  buildTile: (col, row) {
                    if (widget.dataMap!.isNotEmpty) {
                      int bmu = row * widget.columnas + col + 1;
                      String valorDist = widget.dataMap![bmu.toString()]!;
                      String valorDistConPunto = valorDist.replaceAll(',', '.');
                      double valor = double.parse(valorDistConPunto);
                      return HexagonWidgetBuilder(
                        color: getInterpolatedColor(
                            valor, widget.gradiente, widget.dataMap),
                        //color: getColorForValue(valor),
                        //generarColorAleatorioEnEspectro(), //row.isEven ? Colors.yellow : Colors.orangeAccent,
                        elevation: 0.0,
                        padding: widget.paddingEntreHexagonos,
                      );
                    } else {
                      return HexagonWidgetBuilder(
                        color: Colors.white,
                        //generarColorAleatorioEnEspectro(), //row.isEven ? Colors.yellow : Colors.orangeAccent,
                        elevation: 0.0,
                        padding: 0.6,
                      );
                    }
                  },
                  buildChild: (col, row) {
                    return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            textStyle: const TextStyle(
                              // Tamaño del texto
                              color: Colors.black, // Color del texto
                            ),
                            backgroundColor:
                                Colors.transparent, // Fondo transparente
                            //onPrimary: Colors.blue, // Color del texto cuando se presiona
                            elevation: 0, // Elimina la sombra del botón
                            // shape: RoundedRectangleBorder(
                            //   borderRadius: BorderRadius.circular(8.0),
                            //side: BorderSide(color: Colors.blue), // Borde del color deseado
                            //),
                            padding: EdgeInsets.all(0.0)),
                        onPressed: () {
                          //loadData();
                          showDialog<void>(
                            context: context,
                            builder: (BuildContext context) {
                              int bMU = row * widget.columnas + col + 1;
                              String valorDist =
                                  widget.dataMap![bMU.toString()]!;

                              return AlertDialog(
                                title: const Text('Información'),
                                content: SingleChildScrollView(
                                  child: ListBody(
                                    children: [
                                      const Text(
                                          'Este es un cuadro de diálogo de ejemplo.'),
                                      Text('BMU = $bMU'),
                                      Text('Udist = $valorDist'),
                                    ],
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(); // Cerrar el cuadro de diálogo
                                    },
                                    child: Text('Cerrar'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: const Text(
                          '',
                          //'123456789',
                          //'$BMU',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ));
                  }),
            ),
          ),
        ],
      ),
      
    );
    
  }

  void save() async {
    final boundary =
        _widgetKey.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: 2);
    final byteData = await image.toByteData(format: ImageByteFormat.png);

    Uint8List pngBytes = byteData!.buffer.asUint8List();

    final blob = html.Blob([pngBytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    // ignore: unused_local_variable
    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', "UMatrixSimple.png")
      ..click();

    html.Url.revokeObjectUrl(url);

    // showDialog(
    //   context: context,
    //   builder: (BuildContext context) {
    //     return AlertDialog(
    //       title: Text('Imagen generada'),
    //       content: Container(
    //         child: Image.memory(pngBytes),
    //       ),
    //       actions: <Widget>[
    //         TextButton(
    //           onPressed: () {
    //             Navigator.of(context).pop();
    //           },
    //           child: Text('Cerrar'),
    //         ),
    //       ],
    //     );
    //   },
    // );
  }
}
