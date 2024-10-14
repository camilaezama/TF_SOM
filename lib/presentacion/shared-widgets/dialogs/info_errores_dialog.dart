import 'package:TF_SOM_UNMdP/providers/datos_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InfoErroresDialog extends StatefulWidget {
  final double widthPantalla;
  final double heightPantalla;

  const InfoErroresDialog(
      {super.key, required this.widthPantalla, required this.heightPantalla});

  @override
  State<InfoErroresDialog> createState() => _InfoErroresDialogState();
}

class _InfoErroresDialogState extends State<InfoErroresDialog> {
  @override
  Widget build(BuildContext context) {
    final datosProvider = context.read<DatosProvider>();

    return AlertDialog(
      title: const Text('Información'),
      content: SizedBox(
        width: widget.widthPantalla * 0.5,
        height: widget.heightPantalla * 0.7,
        child: Column(
          children: [
            SizedBox(
              width: widget.widthPantalla * 0.5,
              height: widget.heightPantalla * 0.6,
              child: SingleChildScrollView(
                child: Column(

                    children: [
                      const Text('Parametros', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),                      
                      ...listaTextos(
                        datosProvider.resultadoEntrenamiento.parametros),
                      const SizedBox(
                        height: 10.0,
                      ),
                      const Divider(),
                      const SizedBox(
                        height: 10.0,
                      ),
                      const Text('Errores', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),
                      ...listaTextos(
                        datosProvider.resultadoEntrenamiento.errores),
                    ]
                    
                    

                    ),
              ),
            ),
            SizedBox(
              width: widget.widthPantalla * 0.5,
              height: widget.heightPantalla * 0.1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      //Descargar archivo de texto con resultado
                      DateTime now = DateTime.now();
                      datosProvider.downloadSummaryTxtFile(
                          datosProvider.resultadoEntrenamiento.parametros,
                          datosProvider.resultadoEntrenamiento.errores,
                          "ResumenEntrenamiento-$now.txt");
                    },
                    label: const Text('Errores'),
                    icon: const Icon(Icons.download),
                  ),
                  const SizedBox(width: 20.0,),
                  TextButton.icon(
                    onPressed: () {
                      datosProvider.descargarResultadoEntrenamiento();
                    },
                    label: const Text('Resultado entrenamiento'),
                    icon: const Icon(Icons.download),
                  ),
                  const SizedBox(width: 20.0,),
                  TextButton.icon(
                    onPressed: () {
                      datosProvider.descargarCodebook();
                    },
                    label: const Text('Codebook'),
                    icon: const Icon(Icons.download),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

List<Widget> listaTextos(Map<String, String> textos) {
  List<Widget> listaWidgets = [];

  textos.forEach((key, value) {
    listaWidgets.add(Row(children: [
      Text(key, style: const TextStyle(fontWeight: FontWeight.bold)),
      const Text('  :  '),
      Text('$value')
    ]));
  });

  return listaWidgets;
}
