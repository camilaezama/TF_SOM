import 'package:TF_SOM_UNMdP/presentacion/shared-widgets/grilla_hexagonos.dart';
import 'package:TF_SOM_UNMdP/providers/datos_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HitsPestana extends StatelessWidget {

  final Gradient gradiente;

  const HitsPestana({super.key, required this.gradiente});

  @override
  Widget build(BuildContext context) {

    final datosProvider = context.read<DatosProvider>();
    
    return GrillaHexagonos(
      titulo: "Hits",
      gradiente: gradiente,
      codebook: datosProvider.codebook,
      nombreColumnas: datosProvider.nombresColumnas,
      dataMap: datosProvider.dataUdist,
      filas: datosProvider.filas,
      columnas: datosProvider.columnas,
      hits: true,
      hitsMap: datosProvider.hitsMap,
    );
  }
}