import 'package:flutter/material.dart';

class DropdownMenuComponentes extends StatefulWidget {
  final List<String> listaOpciones;
  const DropdownMenuComponentes({super.key,required this.listaOpciones});
  @override
  State<DropdownMenuComponentes> createState() =>
      _DropdownMenuComponentesState();
}

class _DropdownMenuComponentesState extends State<DropdownMenuComponentes> {
  String dropdownValue = '';

  @override

  Widget build(BuildContext context) {
    return DropdownMenu<String>(
      initialSelection: widget.listaOpciones.first,
      onSelected: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValue = value!;
        });
      },
      dropdownMenuEntries: widget.listaOpciones.map<DropdownMenuEntry<String>>((String value) {
        return DropdownMenuEntry<String>(value: value, label: value);
      }).toList(),
    );
  }
}
