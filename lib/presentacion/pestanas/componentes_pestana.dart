import 'package:TF_SOM_UNMdP/presentacion/shared-widgets/dialogs/seleccionar_opciones_dialog.dart';
import 'package:TF_SOM_UNMdP/presentacion/shared-widgets/grilla_hexagonos.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter/rendering.dart';
import 'dart:typed_data';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:TF_SOM_UNMdP/utils/mostrar_dialog_texto.dart';

class ComponentesPestana extends StatefulWidget {
  final Map<String, dynamic> mapaRta;
  final List<List<double>> codebook;
  final int filas;
  final int columnas;
  final List<String> nombrecolumnas;
  final Gradient gradiente;
  const ComponentesPestana(
      {super.key,
      required this.mapaRta,
      required this.codebook,
      required this.filas,
      required this.nombrecolumnas,
      required this.columnas,
      required this.gradiente});

  @override
  State<ComponentesPestana> createState() => _ComponentesPestanaState();
}

class _ComponentesPestanaState extends State<ComponentesPestana>
    with AutomaticKeepAliveClientMixin {
  List<String> opciones = [];
  List<bool> seleccionadas = [];
  List<String> opcionesSeleccionadas = [];
  late List<int> opcionesGrillasPorFila;
  late int opcionGrillasPorFila;
  bool _mostrarGradiente = true;
  bool _mostrarBotonImprimir = false;

  @override
  void initState() {
    super.initState();
    //Ignora las primeras 6 (i = 7) porque son BMU, Udist, etc etc, me quedo con las que son componentes

    for (var i = 0; i < widget.nombrecolumnas.length; i++) {
      seleccionadas.add(false);
    }

    opcionesGrillasPorFila = [2, 3, 4, 5, 6];
    opcionGrillasPorFila = 2;
  }

  final _widgetKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    super.build(context);
    double sizeWidth = MediaQuery.of(context).size.width;
    double sizeHeight = MediaQuery.of(context).size.height;

    return Column(
      children: [
        Row(
          children: [
            const Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Text("Cantidad de componentes por fila:"),
            ),
            DropdownButton<int>(
              value: opcionGrillasPorFila,
              items: opcionesGrillasPorFila.map((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text(value.toString()),
                );
              }).toList(),
              onChanged: (int? newValue) {
                if (newValue != null) {
                  setState(() {
                    opcionGrillasPorFila = newValue;
                  });
                }
              },
            ),
            SizedBox(width: 20),
            IconButton(
              icon: Icon(Icons.list),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return DialogOpciones(
                      opciones: widget.nombrecolumnas,
                      seleccionadas: seleccionadas,
                      actualizarOpciones: actualizarOpciones,
                    );
                  },
                );
              },
              //onPressed: () => {_mostrarListaOpciones(context)},
            ),
            SizedBox(width: 20),
            IconButton(
              tooltip: "Mostrar gradiente",
              icon: _mostrarGradiente
                  ? Icon(Icons.visibility)
                  : Icon(Icons.visibility_off),
              onPressed: () {
                setState(() {
                  _mostrarGradiente = !_mostrarGradiente;
                });
              },
            ),
            SizedBox(width: 20),
            ElevatedButton(onPressed: save, child: const Icon(Icons.download))
          ],
        ),
        opcionGrillasPorFila == 2
            ? grillas2(sizeWidth, sizeHeight)
            : grillas(sizeWidth, sizeHeight, opcionGrillasPorFila)
      ],
    );
  }

  Widget grillas2(double sizeWidth, double sizeHeight) {
    return Expanded(
      child: RepaintBoundary(
        key: _widgetKey,
        child: ListView.builder(
          itemCount: (opcionesSeleccionadas.length / 2).ceil(),
          itemBuilder: (context, index) {
            var dataMap = widget.mapaRta[opcionesSeleccionadas[index * 2]];
            List<double> doubleValues = dataMap.values
                .map((value) => double.tryParse(value))
                .where((value) => value != null && value != -1)
                .toList()
                .cast<double>();

            double minValue = doubleValues.reduce((a, b) => a < b ? a : b);
            double maxValue = doubleValues.reduce((a, b) => a > b ? a : b);
            double minValue1 = 0;
            double maxValue1 = 1;
            if (index * 2 + 1 < opcionesSeleccionadas.length) {
              dataMap = widget.mapaRta[opcionesSeleccionadas[index * 2 + 1]];
              doubleValues = dataMap.values
                  .map((value) => double.tryParse(value))
                  .where((value) => value != null && value != -1)
                  .toList()
                  .cast<double>();

              minValue1 = doubleValues.reduce((a, b) => a < b ? a : b);
              maxValue1 = doubleValues.reduce((a, b) => a > b ? a : b);
            }

            return Row(
              children: [
                Container(
                  width: sizeWidth / 2,
                  height: sizeHeight / 2,
                  child: GrillaHexagonos(
                    titulo: opcionesSeleccionadas[index * 2],
                    gradiente: widget.gradiente,
                    codebook: widget.codebook,
                    nombreColumnas: widget.nombrecolumnas,
                    dataMap: widget.mapaRta[opcionesSeleccionadas[index * 2]],
                    filas: widget.filas,
                    columnas: widget.columnas,
                    mostrarGradiente: _mostrarGradiente,
                    mostrarBotonImprimir: _mostrarBotonImprimir,
                    min: minValue,
                    max: maxValue,
                  ),
                  //child: Text(opciones[index * 2]),
                ),
                (index * 2 + 1 < opcionesSeleccionadas.length)
                    ? Container(
                        width: sizeWidth / 2,
                        height: sizeHeight / 2,
                        child: GrillaHexagonos(
                          titulo: opcionesSeleccionadas[index * 2 + 1],
                          gradiente: widget.gradiente,
                          codebook: widget.codebook,
                          nombreColumnas: widget.nombrecolumnas,
                          dataMap: widget
                              .mapaRta[opcionesSeleccionadas[index * 2 + 1]],
                          filas: widget.filas,
                          columnas: widget.columnas,
                          mostrarGradiente: _mostrarGradiente,
                          mostrarBotonImprimir: _mostrarBotonImprimir,
                          min: minValue1,
                          max: maxValue1,
                        ),
                        //child: Text(opciones[index * 2]),
                      )
                    : Text(""),
                // Expanded(child:
                //     // child: Text((index * 2 + 1 < opciones.length)
                //     //     ? opciones[index * 2 + 1]
                //     //     : ""),
                //     ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget grillas(double sizeWidth, double sizeHeight, int grillasPorFila) {
    return Expanded(
      child: RepaintBoundary(
        key: _widgetKey,
        child: ListView.builder(
          itemCount: (opcionesSeleccionadas.length / grillasPorFila).ceil(),
          itemBuilder: (context, index) {
            int startIndex = index * grillasPorFila;
            int endIndex = startIndex + grillasPorFila;
            if (endIndex > opcionesSeleccionadas.length) {
              endIndex = opcionesSeleccionadas.length;
            }
            List<String> currentOptions =
                opcionesSeleccionadas.sublist(startIndex, endIndex);
            return Row(
              children: currentOptions.map((option) {
                var dataMap = widget.mapaRta[option];
                List<double> doubleValues = dataMap.values
                    .map((value) => double.tryParse(value))
                    .where((value) => value != null && value != -1)
                    .toList()
                    .cast<double>();

                double minValue = doubleValues.reduce((a, b) => a < b ? a : b);
                double maxValue = doubleValues.reduce((a, b) => a > b ? a : b);
                return Container(
                  width: sizeWidth / grillasPorFila,
                  height: sizeHeight / grillasPorFila,
                  child: GrillaHexagonos(
                    titulo: option,
                    gradiente: widget.gradiente,
                    nombreColumnas: widget.nombrecolumnas,
                    codebook: widget.codebook,
                    dataMap: widget.mapaRta[option],
                    filas: widget.filas,
                    columnas: widget.columnas,
                    mostrarGradiente: _mostrarGradiente,
                    mostrarBotonImprimir: _mostrarBotonImprimir,
                    min: minValue,
                    max: maxValue,
                  ),
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }

  void actualizarOpciones(List<bool> opcionesSeleccionadasBool) {
    seleccionadas = opcionesSeleccionadasBool;

    List<String> seleccionadasList = [];

    for (int i = 0; i < widget.nombrecolumnas.length; i++) {
      if (seleccionadas[i]) {
        seleccionadasList.add(widget.nombrecolumnas[i]);
      }
    }
    setState(() {
      opcionesSeleccionadas = seleccionadasList;
    });
  }

  void save() async {
    try {
      final boundary = _widgetKey.currentContext!.findRenderObject()!
          as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 2);
      final byteData = await image.toByteData(format: ImageByteFormat.png);

      Uint8List pngBytes = byteData!.buffer.asUint8List();

      final blob = html.Blob([pngBytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      DateTime now = new DateTime.now();
      final anchor = html.AnchorElement(href: url)
        ..setAttribute('download', "MapaComponentes-$now.png")
        ..click();

      html.Url.revokeObjectUrl(url);
    } catch (e) {
      // ignore: use_build_context_synchronously
      mostrarDialogTexto(context, 'Error al descargar',
          'Debe seleccionar dos o mas componentes.');
    }
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
