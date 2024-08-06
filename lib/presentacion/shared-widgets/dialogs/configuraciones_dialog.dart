import 'package:TF_SOM_UNMdP/presentacion/shared-widgets/radioButtonsConfig.dart';
import 'package:TF_SOM_UNMdP/providers/config_provider.dart';
import 'package:TF_SOM_UNMdP/providers/parametros_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ConfiguracionesDialog extends StatefulWidget {
  final double widthPantalla;
  final double heightPantalla;

  const ConfiguracionesDialog(
      {super.key, required this.widthPantalla, required this.heightPantalla});

  @override
  State<ConfiguracionesDialog> createState() => _ConfiguracionesDialogState();
}

class _ConfiguracionesDialogState extends State<ConfiguracionesDialog> {
  late TextEditingController IPController;
  late TextEditingController puertoController;
  late String hosteado = 'host';

  @override
  void initState() {
    final configProvider = context.read<ConfigProvider>();
    IPController = TextEditingController(text: configProvider.IP);
    puertoController = TextEditingController(text: configProvider.puerto);

    super.initState();
  }

  void changeHosteado(String hostValue) {
    setState(() {
      hosteado = hostValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Configuracion'),
      content: SizedBox(
        width: widget.widthPantalla * 0.5,
        height: widget.heightPantalla * 0.5,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  RadioButtonsHost(
                    getValue: changeHosteado,
                  )
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                        enabled: hosteado!='host',
                        controller: IPController,
                        keyboardType: TextInputType.url,
                        //inputFormatters: [
                        //  FilteringTextInputFormatter.digitsOnly
                        //],
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Dirección IP')),
                  ),
                  const SizedBox(
                    width: 25,
                  ),
                  Expanded(
                    child: TextField(
                      enabled: hosteado!='host',
                      controller: puertoController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), labelText: 'Puerto'),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            var configProvider = context.read<ConfigProvider>();
            configProvider.updateConfig(
                IP: IPController.text,
                puerto: puertoController.text,
                hosteado: hosteado);
            Navigator.of(context).pop(); // Cerrar el cuadro de diálogo
          },
          child: const Text('Cerrar'),
        ),
      ],
    );
  }
}
