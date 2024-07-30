import 'package:TF_SOM_UNMdP/config/tema.dart';
import 'package:TF_SOM_UNMdP/presentacion/shared-widgets/grilla_hexagonos.dart';
import 'package:TF_SOM_UNMdP/providers/clusters_provider.dart';
import 'package:TF_SOM_UNMdP/providers/datos_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ClustersPestana extends StatefulWidget {
  final Gradient gradiente;
  const ClustersPestana({super.key, required this.gradiente});

  @override
  State<ClustersPestana> createState() => _ClustersPestanaState();
}

class _ClustersPestanaState extends State<ClustersPestana>
    with AutomaticKeepAliveClientMixin {
  late TextEditingController clustersController;
  String botonAceptar = 'Aceptar';

  @override
  void initState() {
    context.read<ClustersProvider>().mostarGrilla = false;
    clustersController = TextEditingController(text: "5");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final datosProvider = context.read<DatosProvider>();
    final clustersProvider = context.watch<ClustersProvider>();

    return Center(
      child: Column(
        children: [
          const SizedBox(
            height: 25,
          ),
          SizedBox(
            width: 250, // Set the desired width here
            child: TextField(
              controller: clustersController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Cantidad de clusters',
              ),
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          ElevatedButton(
              onPressed: () {
                clustersProvider.llamadaClustering(
                    context, clustersController.text);
              },
              style: AppTheme.primaryButtonStyle,
              child: clustersProvider.cargando
                  ? const CircularProgressIndicator()
                  : Text(
                      botonAceptar,
                      style: const TextStyle(fontSize: 16),
                    )),
          clustersProvider.mostarGrilla
              ? Expanded(
                  child: GrillaHexagonos(
                    gradiente: widget.gradiente,
                    dataMap: datosProvider.resultadoEntrenamiento.dataUdist,
                    filas: datosProvider.resultadoEntrenamiento.filas,
                    nombreColumnas:
                        datosProvider.resultadoEntrenamiento.nombresColumnas,
                    clusters: clustersProvider.mapaRtaClusters,
                    codebook: datosProvider.resultadoEntrenamiento.codebook,
                    columnas: datosProvider.resultadoEntrenamiento.columnas,
                    titulo: "Clustering",
                    mostrarGradiente: false,
                    min: 0,
                    max: 1,
                  ),
                )
              : const Text("")
        ],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
