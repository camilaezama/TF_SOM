import 'package:TF_SOM_UNMdP/DialogOpciones.dart';
import 'package:TF_SOM_UNMdP/grillaHexagonos.dart';
import 'package:flutter/material.dart';

class ComponentesPage extends StatefulWidget {
  final Map<String, dynamic> mapaRta;
  final int filas;
  final int columnas;
  const ComponentesPage(
      {super.key,
      required this.mapaRta,
      required this.filas,
      required this.columnas});

  @override
  State<ComponentesPage> createState() => _ComponentesPageState();
}

class _ComponentesPageState extends State<ComponentesPage> {
  List<String> opciones = [];
  List<bool> seleccionadas = [];
  List<String> opcionesSeleccionadas = [];
  late Gradient gradiente;
  late List<int> opcionesGrillasPorFila;
  late int opcionGrillasPorFila;
  bool _mostrarGradiente = true;
  bool _mostrarBotonImprimir = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    gradiente = const LinearGradient(
      colors: [
        Color.fromARGB(255, 8, 82, 143),
        Colors.blue,
        Colors.green,
        Colors.yellow,
        Colors.orange,
        Colors.red,
      ],
      stops: [0.0, 0.2, 0.4, 0.6, 0.8, 1.0],
    );

    //Ignora las primeras 6 (i = 7) porque son BMU, Udist, etc etc, me quedo con las que son componentes
    List<String> keys = widget.mapaRta.keys.toList();
    for (var i = 7; i < keys.length; i++) {
      opciones.add(keys[i]);
      seleccionadas.add(false);
    }

    opcionesGrillasPorFila = [2, 3, 4, 5, 6];
    opcionGrillasPorFila = 2;
  }

  @override
  Widget build(BuildContext context) {
    print((opciones.length / 2).ceil());
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
                      opciones: opciones,
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
            icon: _mostrarGradiente ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
            onPressed: () {
              setState(() {
                _mostrarGradiente = !_mostrarGradiente;
              });
            },
          ),
          ],
        ),
        opcionGrillasPorFila == 2 ? grillas2(sizeWidth, sizeHeight) : grillas(sizeWidth, sizeHeight, opcionGrillasPorFila)
        
      ],
    );
  }

  Widget grillas2(double sizeWidth, double sizeHeight) {
    return Expanded(
      child: ListView.builder(
        itemCount: (opcionesSeleccionadas.length / 2).ceil(),
        itemBuilder: (context, index) {
          return Row(
            children: [
              Container(
                width: sizeWidth / 2,
                height: sizeHeight / 2,
                child: GrillaHexagonos(
                    titulo: opcionesSeleccionadas[index * 2],
                    gradiente: gradiente,
                    dataMap: widget.mapaRta[opcionesSeleccionadas[index * 2]],
                    filas: widget.filas,
                    columnas: widget.columnas,
                    mostrarGradiente: _mostrarGradiente,
                    mostrarBotonImprimir: _mostrarBotonImprimir,),
                //child: Text(opciones[index * 2]),
              ),
              (index * 2 + 1 < opcionesSeleccionadas.length)
                  ? Container(
                      width: sizeWidth / 2,
                      height: sizeHeight / 2,
                      child: GrillaHexagonos(
                          titulo: opcionesSeleccionadas[index * 2 + 1],
                          gradiente: gradiente,
                          dataMap: widget
                              .mapaRta[opcionesSeleccionadas[index * 2 + 1]],
                          filas: widget.filas,
                          columnas: widget.columnas,
                          mostrarGradiente: _mostrarGradiente,
                          mostrarBotonImprimir: _mostrarBotonImprimir),
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
    );
  }

  Widget grillas(double sizeWidth, double sizeHeight, int grillasPorFila) {
    return Expanded(
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
              return Container(
                width: sizeWidth / grillasPorFila,
                height: sizeHeight / grillasPorFila,
                child: GrillaHexagonos(
                    titulo: option,
                    gradiente: gradiente,
                    dataMap: widget.mapaRta[option],
                    filas: widget.filas,
                    columnas: widget.columnas,
                    mostrarGradiente: _mostrarGradiente,
                    mostrarBotonImprimir: _mostrarBotonImprimir),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  void actualizarOpciones(List<bool> opcionesSeleccionadasBool) {
    seleccionadas = opcionesSeleccionadasBool;

    List<String> seleccionadasList = [];

    for (int i = 0; i < opciones.length; i++) {
      if (seleccionadas[i]) {
        seleccionadasList.add(opciones[i]);
      }
    }
    setState(() {
      opcionesSeleccionadas = seleccionadasList;
    });
  }
}
