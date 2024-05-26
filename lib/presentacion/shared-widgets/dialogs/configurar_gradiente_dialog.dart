import 'package:TF_SOM_UNMdP/config/gradientes.dart';
import 'package:TF_SOM_UNMdP/providers/gradiente_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConfigurarGradienteDialog extends StatefulWidget {
  final double widthPantalla;
  final double heightPantalla;
  const ConfigurarGradienteDialog(
      {super.key, required this.widthPantalla, required this.heightPantalla});

  @override
  State<ConfigurarGradienteDialog> createState() =>
      _ConfigurarGradienteDialogState();
}

class _ConfigurarGradienteDialogState extends State<ConfigurarGradienteDialog> {

  late int selectedIndex;

  @override
  void initState() {
    super.initState();
    final gradienteProvider = context.read<GradienteProvider>();
    selectedIndex = gradienteProvider.indexGradienteElegido;
  }

  @override
  Widget build(BuildContext context) {
    final gradienteProvider = context.read<GradienteProvider>();

    return AlertDialog(
      title: const Text('Elegir gradiente'),
      actions: [
        TextButton(
          onPressed: (){
            gradienteProvider.indexGradienteElegido = selectedIndex;
            Navigator.of(context).pop();
          }, 
          child: const Text('Guardar'))
      ],
      content: SizedBox(
        width: widget.widthPantalla * 0.4,
        height: widget.heightPantalla * 0.5,
        child: ListView.builder(
          itemCount: listaGradientes.length,
          itemBuilder: (context, index) {
            Gradient grad = listaGradientes[index];

            return ListTile(
              title: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                child: Container(
                  height: 50,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: grad.colors))),
              ),
              leading: Radio<int>(
                value: index,
                groupValue: selectedIndex,
                onChanged: (int? value) {
                  setState(() {
                    selectedIndex = value!;
                  });
                },
              ),
              onTap: () {
                setState(() {
                  selectedIndex = index;
                });
              },
            );
          },
        ),
      ),
    );
  }
}
