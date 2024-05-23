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
        
    return GrillaHexagonos(
        titulo: "BMU",
        gradiente: gradiente,
        dataMap: datosProvider.dataUdist,
        nombreColumnas: datosProvider.nombresColumnas,
        codebook: datosProvider.codebook,
        clusters: null,
        filas: datosProvider.filas,
        columnas: datosProvider.columnas);
  }
}