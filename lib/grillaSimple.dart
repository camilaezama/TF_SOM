import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils.dart';
import 'package:hexagon/hexagon.dart';

class GrillaSimple extends StatefulWidget {
  final Gradient? gradiente;
  final Map<String, String>? dataMap;
  const GrillaSimple({super.key, this.gradiente, this.dataMap});

  @override
  State<GrillaSimple> createState() => _GrillaSimpleState();
}

class _GrillaSimpleState extends State<GrillaSimple> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
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
        InteractiveViewer(
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
      ],
    );
  }
}
