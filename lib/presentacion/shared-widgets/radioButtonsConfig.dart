import 'package:TF_SOM_UNMdP/providers/config_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RadioButtonsHost extends StatefulWidget {
  final Function getValue;
  final TextEditingController IPController;
  final TextEditingController puertoController;

  const RadioButtonsHost({super.key, required this.getValue, required this.IPController, required this.puertoController});
  @override
  _RadioButtonsHostState createState() => _RadioButtonsHostState();
}

class _RadioButtonsHostState extends State<RadioButtonsHost> {
  // Variable to keep track of the selected radio button
  late String? _selectedOption;

  @override
  void initState() {
    final configProvider = context.read<ConfigProvider>();
    _selectedOption = configProvider.selectedOption;
    super.initState();
  }

  void volverCamposAPorDefecto(){
    var configProvider = context.read<ConfigProvider>();
    widget.IPController.text = configProvider.defaultIP;
    widget.puertoController.text = configProvider.defaultPuerto;
    configProvider.updateConfig(
      IP: configProvider.defaultIP, 
      puerto: configProvider.defaultPuerto, 
      hosteado: 'host'
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Radio<String>(
                value: 'host',
                groupValue: _selectedOption,
                onChanged: (String? value) {
                  widget.getValue(value);
                  setState(() {
                    _selectedOption = value;
                    var configProvider = context.read<ConfigProvider>();
                    configProvider.updateSelectedOption(opcion: value);
                    volverCamposAPorDefecto();
                  });
                },
              ),
              const Text('Por defecto'),
              const SizedBox(
                width: 200,
              ),
              Radio<String>(
                value: 'manual',
                groupValue: _selectedOption,
                onChanged: (String? value) {
                  widget.getValue(value);
                  setState(() {
                    _selectedOption = value;
                    var configProvider = context.read<ConfigProvider>();
                    configProvider.updateSelectedOption(opcion: value);
                  });
                },
              ),
              const Text('Manual'),
            ],
          ),
        ],
      ),
    );
  }
}
