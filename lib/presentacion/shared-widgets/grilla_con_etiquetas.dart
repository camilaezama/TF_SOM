import 'package:TF_SOM_UNMdP/config/tema.dart';
import 'package:TF_SOM_UNMdP/presentacion/shared-widgets/grilla_hexagonos.dart';
import 'package:TF_SOM_UNMdP/providers/datos_provider.dart';
import 'package:TF_SOM_UNMdP/utils/colores_hits.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GrillaConEtiquetas extends StatefulWidget {
    // {4: {Datos: [1]}, 6: {Datos: [2,4]}, ...}
  final Map<int, Map<String, List<String>>> mapaBMUconEtiquetas;
  // {Datos: [1,2,3,4]}
  final Map<String, List<String>> etiquetasMap;
  final Gradient gradiente;
  final String tituloGrilla;
  final String tituloColumnaEtiquetas;

  GrillaConEtiquetas({
    super.key, 
    required this.mapaBMUconEtiquetas, 
    required this.etiquetasMap, 
    required this.gradiente, required this.tituloGrilla, 
    required this.tituloColumnaEtiquetas,
  });

  @override
  State<GrillaConEtiquetas> createState() => _GrillaConEtiquetasState();
}

class _GrillaConEtiquetasState extends State<GrillaConEtiquetas> {

  late String selectedKey ;
  late List<String> selectedValues;
  late Map<String, Color> mapaColores;

  @override
  void initState() {
    super.initState();
    selectedKey = widget.etiquetasMap.keys.first;
    selectedValues = widget.etiquetasMap[selectedKey]!;
    mapaColores = generateColorMap(selectedValues);
  }

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

        final datosProvider = context.read<DatosProvider>();
    List<double> doubleValues = datosProvider
        .resultadoEntrenamiento.dataUdist.values
        .map((value) => double.tryParse(value))
        .where((value) => value != null && value != -1)
        .toList()
        .cast<double>();

    double minValue = doubleValues.reduce((a, b) => a < b ? a : b);
    double maxValue = doubleValues.reduce((a, b) => a > b ? a : b);

    return Row(
            children: [
              if (datosProvider.resultadoEntrenamiento.etiquetas != [])
                Container(
                  color: AppTheme.colorFondoGris,
                  width: size.width * 0.15,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Center(
                          child: Text(widget.tituloColumnaEtiquetas, style: AppTheme.titulo1)),
                      const SizedBox(height: 20),
                      Center(
                        child: DropdownButton<String>(
                          value: selectedKey,
                          hint: const Text('Seleccionar una opción'),
                          items: widget.etiquetasMap.keys.map((String key) {
                            return DropdownMenuItem<String>(
                              value: key,
                              child: Text(key),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedKey = newValue!;
                              selectedValues = widget.etiquetasMap[newValue]!;
                              mapaColores = generateColorMap(selectedValues);
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
                titulo: widget.tituloGrilla,
                gradiente: widget.gradiente,
                codebook: datosProvider.resultadoEntrenamiento.codebook,
                nombreColumnas:
                    datosProvider.resultadoEntrenamiento.nombresColumnas,
                dataMap: datosProvider.resultadoEntrenamiento.dataUdist,
                filas: datosProvider.resultadoEntrenamiento.filas,
                columnas: datosProvider.resultadoEntrenamiento.columnas,
                hits: true,
                hitsMap: datosProvider.resultadoEntrenamiento.hitsMap,
                min: minValue,
                max: maxValue,
                //etiquetas: datosProvider.resultadoEntrenamiento.etiquetas,
                mapaBMUconEtiquetas: widget.mapaBMUconEtiquetas,
                etiquetasMap: widget.etiquetasMap,
                selectedKey: selectedKey,
                mapaColores: mapaColores,
              ),
            ],
          );
  }
}