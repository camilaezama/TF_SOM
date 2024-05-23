import 'package:TF_SOM_UNMdP/presentacion/shared-widgets/grilla_hexagonos.dart';
import 'package:TF_SOM_UNMdP/providers/datos_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UmatPestana extends StatelessWidget {

  final Gradient gradiente;
  const UmatPestana({super.key, required this.gradiente});

  @override
  Widget build(BuildContext context) {

    final datosProvider = context.read<DatosProvider>();
    
    return GrillaHexagonos(
        titulo: "UMat",
        gradiente: gradiente,
        dataMap: datosProvider.resultadoEntrenamiento.mapaRtaUmat,
        nombreColumnas: datosProvider.resultadoEntrenamiento.nombresColumnas,
        codebook: datosProvider.resultadoEntrenamiento.codebook,
        filas: datosProvider.resultadoEntrenamiento.filas * 2,
        columnas: datosProvider.resultadoEntrenamiento.columnas * 2,
        paddingEntreHexagonos: 0.2);
  }
}