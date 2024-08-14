import 'package:TF_SOM_UNMdP/presentacion/shared-widgets/grilla_hexagonos.dart';
import 'package:TF_SOM_UNMdP/providers/datos_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BmuPestana extends StatelessWidget {
  final Gradient gradiente;

  BmuPestana({super.key, required this.gradiente});

  @override
  Widget build(BuildContext context) {
    final datosProvider = context.read<DatosProvider>();
    List<double> doubleValues = datosProvider
        .resultadoEntrenamiento.dataUdist.values
        .map((value) => double.tryParse(value))
        .where((value) => value != null && value != -1)
        .toList()
        .cast<double>();

    double minValue = doubleValues.reduce((a, b) => a < b ? a : b);
    double maxValue = doubleValues.reduce((a, b) => a > b ? a : b);
    return GrillaHexagonos(
      titulo: "Mapa",
      gradiente: gradiente,
      dataMap: datosProvider.resultadoEntrenamiento.dataUdist,
      nombreColumnas: datosProvider.resultadoEntrenamiento.nombresColumnas,
      codebook: datosProvider.resultadoEntrenamiento.codebook,
      clusters: null,
      filas: datosProvider.resultadoEntrenamiento.filas,
      columnas: datosProvider.resultadoEntrenamiento.columnas,
      min: minValue,
      max: maxValue,
    );
  }
}
