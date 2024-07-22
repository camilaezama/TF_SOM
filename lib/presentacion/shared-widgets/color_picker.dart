
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ListaColorPicker extends StatefulWidget {
  final Map<int, Color> listaIdColor;
  final Function(Map<int, Color>) onColorsChanged;

  const ListaColorPicker({
    super.key, 
    required this.listaIdColor,
    required this.onColorsChanged,
  });

  @override
  ListaColorPickerState createState() => ListaColorPickerState();
}

class ListaColorPickerState extends State<ListaColorPicker> {
  late Map<int, Color> tempListaIdColor;

  @override
  void initState() {
    super.initState();
    tempListaIdColor = Map.from(widget.listaIdColor);
  }  

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: tempListaIdColor.entries.map((entry) {
          int index = entry.key;
          Color color = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 50,
                  width: 100,
                  color: color,
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    _openColorPicker(index);
                  },
                  child: const Text('Cambiar'),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  void updateColors(Map<int, Color> listaIdColor){
    setState(() {
      tempListaIdColor = listaIdColor;
    });
  }

  void _openColorPicker(int index) {
    Color pickerColor = tempListaIdColor[index]!;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Seleccionar un color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: pickerColor,
              onColorChanged: (Color color) {
                setState(() {
                  pickerColor = color;
                });
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  tempListaIdColor[index] = pickerColor;
                  widget.onColorsChanged(tempListaIdColor);
                });
                Navigator.of(context).pop();
              },
              child: const Text('Select'),
            ),
          ],
        );
      },
    );
  }

  // @override
  // void dispose() {
  //   // Llama al callback con los colores actualizados al cerrar el diálogo
  //   widget.onColorsChanged(tempPixelGroups);
  //   super.dispose();
  // }
}