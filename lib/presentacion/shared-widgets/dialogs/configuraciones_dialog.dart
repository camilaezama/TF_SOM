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
    hosteado = hostValue;
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
              SizedBox(
                height: 50,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
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


//################################ CÓDIGO ANTERIOR  ################################

// //Esto se podria poner en mas funciones a medida que agreguemos mas parametros.
//   Widget _parametrosConfigurables(
//       TextEditingController filasController,
//       TextEditingController columnasController,
//       TextEditingController iteracontroller,
//       TextEditingController factorEntrenamientoController) {
//     return SizedBox(
//       width: _width * 0.5,
//       height: _height * 0.5,
//       child: SingleChildScrollView(
//         child: Column(
//           children: [
//             Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                       controller: filasController,
//                       keyboardType: TextInputType.number,
//                       inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//                       decoration: const InputDecoration(
//                           border: OutlineInputBorder(),
//                           labelText: 'Cantidad de filas')),
//                 ),
//                 const SizedBox(
//                   width: 25,
//                 ),
//                 Expanded(
//                   child: TextField(
//                     controller: columnasController,
//                     keyboardType: TextInputType.number,
//                     inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//                     decoration: const InputDecoration(
//                         border: OutlineInputBorder(),
//                         labelText: 'Cantidad de columnas'),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(
//               height: 20,
//             ),
//             Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                       keyboardType: TextInputType.number,
//                       controller: iteracontroller,
//                       inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//                       decoration: const InputDecoration(
//                           border: OutlineInputBorder(),
//                           labelText:
//                               'Cantidad máxima de iteraciones por época')),
//                 ),
//                 const SizedBox(
//                   width: 25,
//                 ),
//                 Expanded(
//                   child: TextField(
//                       keyboardType: TextInputType.number,
//                       controller: factorEntrenamientoController,
//                       inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//                       decoration: const InputDecoration(
//                           border: OutlineInputBorder(),
//                           labelText:
//                               'Factor de incremento iteraciones del entrenamiento')),
//                 )
//               ],
//             ),
//             const SizedBox(
//               height: 20,
//             ),
//             Row(
//               children: [
//                 Expanded(
//                   child: DropdownButtonFormField(
//                     decoration: const InputDecoration(
//                       label: Text("Función de vecindad"),
//                     ),
//                     value: 'gaussian', //valor default
//                     items: const [
//                       DropdownMenuItem(
//                         value: 'gaussian',
//                         child: Text(" Gaussiana"),
//                       ),
//                       DropdownMenuItem(
//                         value: 'bubble',
//                         child: Text(" Burbuja"),
//                       ),
//                     ],
//                     onChanged: (value) {
//                       funcionVecindad = value!;
//                     },
//                   ),
//                 ),
//                 const SizedBox(
//                   width: 25,
//                 ),
//                 Expanded(
//                   child: DropdownButtonFormField(
//                     decoration: const InputDecoration(
//                       label: Text("Inicialización"),
//                     ),
//                     value: 'random', //valor default
//                     items: const [
//                       DropdownMenuItem(
//                         value: 'random',
//                         child: Text(" Aleatoria"),
//                       ),
//                       DropdownMenuItem(
//                         value: 'pca',
//                         child: Text(" PCA"),
//                       ),
//                     ],
//                     onChanged: (value) {
//                       inicializacion = value!;
//                     },
//                   ),
//                 ),
//                 const SizedBox(
//                   width: 25,
//                 ),
//                 Expanded(
//                   child: DropdownButtonFormField(
//                     decoration: const InputDecoration(
//                       label: Text("Normalizacion"),
//                     ),
//                     value: 'var', //valor default
//                     items: const [
//                       DropdownMenuItem(
//                         value: 'var',
//                         child: Text(" Var"),
//                       ),
//                       DropdownMenuItem(
//                         value: 'None',
//                         child: Text(" Ninguna"),
//                       ),
//                     ],
//                     onChanged: (value) {
//                       inicializacion = value!;
//                     },
//                   ),
//                 ),
//                 const SizedBox(
//                   width: 25,
//                 ),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }





// return AlertDialog(
//                                     title:
//                                         const Text('Parametros configurables'),
//                                     content: _parametrosConfigurables(
//                                         filasController,
//                                         columnasController,
//                                         iteracontroller,
//                                         factorEntrenamientoController),
//                                     actions: [
//                                       TextButton(
//                                         onPressed: () {
//                                           Navigator.of(context)
//                                               .pop(); // Cerrar el cuadro de diálogo
//                                         },
//                                         child: const Text('Cerrar'),
//                                       ),
//                                     ],
//                                   );