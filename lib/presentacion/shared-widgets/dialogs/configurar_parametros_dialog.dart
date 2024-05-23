import 'package:TF_SOM_UNMdP/providers/parametros_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ConfigurarParametrosDialog extends StatefulWidget {
  final double widthPantalla;
  final double heightPantalla;

  const ConfigurarParametrosDialog(
      {super.key, required this.widthPantalla, required this.heightPantalla});

  @override
  State<ConfigurarParametrosDialog> createState() =>
      _ConfigurarParametrosDialogState();
}

class _ConfigurarParametrosDialogState
    extends State<ConfigurarParametrosDialog> {
  late TextEditingController filasController;
  late TextEditingController columnasController;
  late TextEditingController iteracontroller;
  late TextEditingController factorEntrenamientoController;

  late String funcionVecindad;
  late String inicializacion;
  late String normalizacion;

  @override
  void initState() {
    final parametrosProvider = context.read<ParametrosProvider>();
    filasController = TextEditingController(text: parametrosProvider.filas);
    columnasController =
        TextEditingController(text: parametrosProvider.columnas);
    iteracontroller = TextEditingController(text: parametrosProvider.itera);
    factorEntrenamientoController =
        TextEditingController(text: parametrosProvider.factorEntrenamiento);
    funcionVecindad = parametrosProvider.funcionVecindad;
    inicializacion = parametrosProvider.inicializacion;
    normalizacion = parametrosProvider.normalizacion;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final parametrosProvider = context.watch<ParametrosProvider>();

    return AlertDialog(
      title: const Text('Parametros configurables'),
      content: SizedBox(
        width: widget.widthPantalla * 0.5,
        height: widget.heightPantalla * 0.5,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                        controller: filasController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Cantidad de filas')),
                  ),
                  const SizedBox(
                    width: 25,
                  ),
                  Expanded(
                    child: TextField(
                      controller: columnasController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Cantidad de columnas'),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                        keyboardType: TextInputType.number,
                        controller: iteracontroller,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText:
                                'Cantidad máxima de iteraciones por época')),
                  ),
                  const SizedBox(
                    width: 25,
                  ),
                  Expanded(
                    child: TextField(
                        keyboardType: TextInputType.number,
                        controller: factorEntrenamientoController,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText:
                                'Factor de incremento iteraciones del entrenamiento')),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField(
                      decoration: const InputDecoration(
                        label: Text("Función de vecindad"),
                      ),
                      value: funcionVecindad, //valor default
                      items: const [
                        DropdownMenuItem(
                          value: 'gaussian',
                          child: Text(" Gaussiana"),
                        ),
                        DropdownMenuItem(
                          value: 'bubble',
                          child: Text(" Burbuja"),
                        ),
                      ],
                      onChanged: (value) {
                        funcionVecindad = value!;
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 25,
                  ),
                  Expanded(
                    child: DropdownButtonFormField(
                      decoration: const InputDecoration(
                        label: Text("Inicialización"),
                      ),
                      value: inicializacion, //valor default
                      items: const [
                        DropdownMenuItem(
                          value: 'random',
                          child: Text(" Aleatoria"),
                        ),
                        DropdownMenuItem(
                          value: 'pca',
                          child: Text(" PCA"),
                        ),
                      ],
                      onChanged: (value) {
                        inicializacion = value!;
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 25,
                  ),
                  Expanded(
                    child: DropdownButtonFormField(
                      decoration: const InputDecoration(
                        label: Text("Normalizacion"),
                      ),
                      value: normalizacion, //valor default
                      items: const [
                        DropdownMenuItem(
                          value: 'var',
                          child: Text(" Var"),
                        ),
                        DropdownMenuItem(
                          value: 'None',
                          child: Text(" Ninguna"),
                        ),
                      ],
                      onChanged: (value) {
                        normalizacion = value!;
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 25,
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
            parametrosProvider.updateParametros(
                filas: filasController.text,
                columnas: columnasController.text,
                itera: iteracontroller.text,
                factorEntrenamiento: factorEntrenamientoController.text,
                funcionVecindad: funcionVecindad,
                inicializacion: inicializacion,
                normalizacion: normalizacion);
            Navigator.of(context).pop(); // Cerrar el cuadro de diálogo
          },
          child: const Text('Cerrar'),
        ),
      ],
    );
  }
}




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