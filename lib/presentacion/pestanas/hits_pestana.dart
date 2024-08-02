import 'package:TF_SOM_UNMdP/presentacion/shared-widgets/grilla_con_etiquetas.dart';
import 'package:TF_SOM_UNMdP/providers/datos_provider.dart';
import 'package:TF_SOM_UNMdP/utils/colores_hits.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HitsPestana extends StatefulWidget {
  final Gradient gradiente;

  const HitsPestana({super.key, required this.gradiente});

  @override
  State<HitsPestana> createState() => _HitsPestanaState();
}

class _HitsPestanaState extends State<HitsPestana> {
  late String selectedKey;
  late List<String> selectedValues;

  ///{101: {Motivos: [OT,ACV,OT], Costos: [1a2,1a2,<=1]}, 13:  {Motivos: [CIA,CIA], Costos: [2a3,1a2], ...}
  Map<int, Map<String, List<String>>> mapaBMUconEtiquetas = {};

  /// {Motivos: [OT,ACV,CIA,NEUM...], Costos: [2a3,1a2,<=1,...]}
  Map<String, List<String>> etiquetasMap = {};

  Map<String, Color> mapaColores = {};

  @override
  void initState() {
    super.initState();

    final datosProvider = context.read<DatosProvider>();

    if (datosProvider.resultadoEntrenamiento.etiquetas != []) {
      Map<String, Set<String>> etiquetasMapSet = {};
      for (var item in datosProvider.resultadoEntrenamiento.etiquetas) {
        int bmu = item['BMU'];
        if (!mapaBMUconEtiquetas.containsKey(bmu)) {
          mapaBMUconEtiquetas[bmu] = {};
        }
        item.forEach((key, value) {
          if (key != 'BMU' && key != 'Dato') {
            if (!mapaBMUconEtiquetas[bmu]!.containsKey(key)) {
              mapaBMUconEtiquetas[bmu]![key] = [];
            }
            mapaBMUconEtiquetas[bmu]![key]!.add(value);

            if (!etiquetasMapSet.containsKey(key)) {
              etiquetasMapSet[key] = {};
            }
            etiquetasMapSet[key]!.add(value);
          }
        });
      }

      etiquetasMapSet.forEach((key, value) {
        etiquetasMap[key] = value.toList();
      });

      selectedKey = etiquetasMap.keys.first;
      selectedValues = etiquetasMap[selectedKey]!;
      mapaColores = generateColorMap(selectedValues);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GrillaConEtiquetas(
        opcionMostrarGrilla: true,
        mapaBMUconEtiquetas: mapaBMUconEtiquetas,
        etiquetasMap: etiquetasMap,
        gradiente: widget.gradiente,
        tituloGrilla: 'Hits',
        tituloColumnaEtiquetas: 'Etiquetas');
  }
}
