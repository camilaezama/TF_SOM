import 'package:flutter/material.dart';

class GenericDropdownMenu extends StatefulWidget {
  final List<String> listaOpciones;
  final Function(String) onSelected;
  const GenericDropdownMenu({
    super.key,
    required this.listaOpciones,
    required this.onSelected,
  });

  @override
  State<GenericDropdownMenu> createState() =>
      _GenericDropdownMenuState();
}

class _GenericDropdownMenuState extends State<GenericDropdownMenu> {
  String dropdownValue = '';

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<String>(
      initialSelection: widget.listaOpciones.first,
      onSelected: (String? value) {
        widget.onSelected(value!);
        setState(() {
          dropdownValue = value!;
        });
      },
      dropdownMenuEntries:
          widget.listaOpciones.map<DropdownMenuEntry<String>>((String value) {
        return DropdownMenuEntry<String>(value: value, label: value);
      }).toList(),
    );
  }
}
