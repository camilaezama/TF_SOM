import 'package:TF_SOM_UNMdP/config/tema.dart';
import 'package:TF_SOM_UNMdP/presentacion/shared-widgets/grilla_hexagonos.dart';
import 'package:TF_SOM_UNMdP/providers/datos_provider.dart';
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
      mapaColores = _generateColorMap(selectedValues);
    }
  }

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

    double widthPantalla = MediaQuery.of(context).size.width;

    final colors = Theme.of(context).colorScheme;

    return Row(
      children: [
        if (datosProvider.resultadoEntrenamiento.etiquetas != [])
          Container(
            color: AppTheme.colorFondoGris,
            width: widthPantalla * 0.15,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Center(child: Text('Etiquetas', style: AppTheme.titulo1)),
                const SizedBox(height: 20),
                Center(
                  child: DropdownButton<String>(
                    value: selectedKey,
                    hint: const Text('Seleccionar una opción'),
                    items: etiquetasMap.keys.map((String key) {
                      return DropdownMenuItem<String>(
                        value: key,
                        child: Text(key),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedKey = newValue!;
                        selectedValues = etiquetasMap[newValue]!;
                        mapaColores = _generateColorMap(selectedValues);
                      });
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: selectedValues.length,
                    itemBuilder: (context, index) {                      
                      return ListTile(
                        title: Text(selectedValues[index]),
                        trailing: Container(
                          width: 20,
                          height: 20,
                          color: mapaColores[selectedValues[index]],
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        GrillaHexagonos(
          titulo: "Hits",
          gradiente: widget.gradiente,
          codebook: datosProvider.resultadoEntrenamiento.codebook,
          nombreColumnas: datosProvider.resultadoEntrenamiento.nombresColumnas,
          dataMap: datosProvider.resultadoEntrenamiento.dataUdist,
          filas: datosProvider.resultadoEntrenamiento.filas,
          columnas: datosProvider.resultadoEntrenamiento.columnas,
          hits: true,
          hitsMap: datosProvider.resultadoEntrenamiento.hitsMap,
          min: minValue,
          max: maxValue,
          etiquetas: datosProvider.resultadoEntrenamiento.etiquetas,
          mapaBMUconEtiquetas: mapaBMUconEtiquetas,
          etiquetasMap: etiquetasMap,
          selectedKey: selectedKey,
          mapaColores: mapaColores,
        ),
      ],
    );
  }
}

Map<String, Color> _generateColorMap(List<String> values) {
  final Map<String, Color> colorMap = {};
  for (int i = 0; i < values.length; i++) {
    colorMap[values[i]] = colores[i % colores.length];
  }
  return colorMap;
}

final List<Color> colores = [
  const Color(0xFF00FF00),
  const Color(0xFF0000FF),
  const Color(0xFFFF0000),
  const Color(0xFF01FFFE),
  const Color(0xFFFFA6FE),
  const Color(0xFFFFDB66),
  const Color(0xFF006401),
  const Color(0xFF010067),
  const Color(0xFF95003A),
  const Color(0xFF007DB5),
  const Color(0xFFFF00F6),
  const Color(0xFFFFEEE8),
  const Color(0xFF774D00),
  const Color(0xFF90FB92),
  const Color(0xFF0076FF),
  const Color(0xFFD5FF00),
  const Color(0xFFFF937E),
  const Color(0xFF6A826C),
  const Color(0xFFFF029D),
  const Color(0xFFFE8900),
  const Color(0xFF7A4782),
  const Color(0xFF7E2DD2),
  const Color(0xFF85A900),
  const Color(0xFFFF0056),
  const Color(0xFFA42400),
  const Color(0xFF00AE7E),
  const Color(0xFF683D3B),
  const Color(0xFFBDC6FF),
  const Color(0xFF263400),
  const Color(0xFFBDD393),
  const Color(0xFF00B917),
  const Color(0xFF9E008E),
  const Color(0xFF001544),
  const Color(0xFFC28C9F),
  const Color(0xFFFF74A3),
  const Color(0xFF01D0FF),
  const Color(0xFF004754),
  const Color(0xFFE56FFE),
  const Color(0xFF788231),
  const Color(0xFF0E4CA1),
];
