import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_application_1/utils.dart';
import 'package:hexagon/hexagon.dart';

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:ui' as ui;
import 'dart:html' as html;
import 'dart:typed_data';

class GrillaSimple extends StatefulWidget {
  final Gradient? gradiente;
  final Map<String, String>? dataMap;
  const GrillaSimple({super.key, this.gradiente, this.dataMap});

  @override
  State<GrillaSimple> createState() => _GrillaSimpleState();
}

class _GrillaSimpleState extends State<GrillaSimple> {
  final _widgetKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ElevatedButton(onPressed: save, child: Icon(Icons.download)),
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
        RepaintBoundary(
          key: _widgetKey,
          child: InteractiveViewer(
            child: HexagonOffsetGrid.evenPointy(
              //color: Colors.yellow.shade100,
              padding: const EdgeInsets.only(
                  left: 50.0, top: 50.0, bottom: 10.0, right: 100.0),
              columns: 24,
              rows: 14,
              buildTile: (col, row) {
                if (widget.dataMap!.isNotEmpty) {
                  int BMU = row * 24 + col + 1;
                  String valorDist = widget.dataMap![BMU.toString()]!;
                  String valorDistConPunto = valorDist.replaceAll(',', '.');
                  double valor = double.parse(valorDistConPunto);
                  return HexagonWidgetBuilder(
                    color: getInterpolatedColor(
                        valor, widget.gradiente, widget.dataMap),
                    //color: getColorForValue(valor),
                    //generarColorAleatorioEnEspectro(), //row.isEven ? Colors.yellow : Colors.orangeAccent,
                    elevation: 0.0,
                    padding: 0.6,
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
              buildChild: (col, row) => ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent, // Fondo transparente
                    //onPrimary: Colors.blue, // Color del texto cuando se presiona
                    elevation: 0, // Elimina la sombra del botón
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      //side: BorderSide(color: Colors.blue), // Borde del color deseado
                    ),
                  ),
                  onPressed: () {
                    //loadData();
                    showDialog<void>(
                      context: context,
                      builder: (BuildContext context) {
                        int bMU = row * 24 + col + 1;
                        String valorDist = widget.dataMap![bMU.toString()]!;

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
                  child: Text('')),
              // child: Text('$col, $row')),
            ),
          ),
        ),
      ],
    );
  }

  void save() async {
    final boundary =
        _widgetKey.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: 2);
    final byteData = await image.toByteData(format: ImageByteFormat.png);

    Uint8List pngBytes = byteData!.buffer.asUint8List();

    // // // Ruta de destino para guardar la imagen
    // String filePath = r'assets\imagen.png';
    // // Escribir los bytes en un archivo
    // await File(filePath).writeAsBytes(pngBytes);

    final blob = html.Blob([pngBytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', "image.png")
      ..click();

    html.Url.revokeObjectUrl(url);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Imagen generada'),
          content: Container(
            child: Image.memory(pngBytes),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  // Future<String> widgetToSvg(GlobalKey key) async {
  // // Create a PictureRecorder to record the widget as an image
  // final recorder = ui.PictureRecorder();
  // final RenderRepaintBoundary boundary = key.currentContext!.findRenderObject() as RenderRepaintBoundary;
  // final image = await boundary.toImage(pixelRatio: 3.0);
  // final canvas = Canvas(recorder);

  // // Convert the widget to an SVG image
  // canvas.drawImage(image, Offset.zero, Paint());
  // final svgBytes = await recorder.endRecording().toSvg();

  // return svgBytes;
  // }
}
