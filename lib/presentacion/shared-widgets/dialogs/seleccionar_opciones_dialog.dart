import 'package:flutter/material.dart';

class DialogOpciones extends StatefulWidget {
  final List<String> opciones;
  final List<bool> seleccionadas;
  final Function(List<bool>) actualizarOpciones;
  final String tituloDialog;
  const DialogOpciones(
      {super.key,
      required this.opciones,
      required this.seleccionadas,
      required this.actualizarOpciones,
      this.tituloDialog = 'Seleccionar opciones'});

  @override
  State<DialogOpciones> createState() => _DialogOpcionesState();
}

class _DialogOpcionesState extends State<DialogOpciones> {
  List<String> opciones = [];
  List<bool> seleccionadas = [];

  @override
  void initState() {
    super.initState();
    opciones = widget.opciones;
    seleccionadas = widget.seleccionadas;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.tituloDialog),
      content: SingleChildScrollView(
        child: Column(
          children: opciones.asMap().entries.map((entry) {
            int index = entry.key;
            String opcion = entry.value;
            return CheckboxListTile(
              title: Text(opcion),
              value: seleccionadas[index],
              onChanged: (bool? valor) {
                setState(() {
                  seleccionadas[index] = valor!;
                });
              },
            );
          }).toList(),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text("Cerrar"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text("Guardar"),
          onPressed: () {
            _mostrarSeleccionadas();
            widget.actualizarOpciones(seleccionadas);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  void _mostrarSeleccionadas() {
    List<String> seleccionadasList = [];

    for (int i = 0; i < opciones.length; i++) {
      if (seleccionadas[i]) {
        seleccionadasList.add(opciones[i]);
      }
    }

    //print(seleccionadasList);
  }
}
