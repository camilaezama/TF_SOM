import 'dart:convert';
import 'dart:ui' as ui;
import 'dart:html' as html;

import 'package:TF_SOM_UNMdP/config/tema.dart';
import 'package:TF_SOM_UNMdP/presentacion/shared-widgets/color_picker.dart';
import 'package:TF_SOM_UNMdP/presentacion/shared-widgets/dialogs/seleccionar_opciones_dialog.dart';
import 'package:TF_SOM_UNMdP/presentacion/shared-widgets/grilla_hexagonos.dart';
import 'package:TF_SOM_UNMdP/presentacion/shared-widgets/tabla_datos.dart';
import 'package:TF_SOM_UNMdP/providers/datos_provider.dart';
import 'package:TF_SOM_UNMdP/providers/imagen_nueva_provider.dart';
import 'package:TF_SOM_UNMdP/providers/parametros_provider.dart';
import 'package:TF_SOM_UNMdP/utils/csv_to_data.dart';
import 'package:TF_SOM_UNMdP/utils/jet_colorMap.dart';
import 'package:TF_SOM_UNMdP/utils/mostrar_dialog_texto.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import '../../utils/utils.dart';

enum TipoColoreado { clustering, coloreadoContinuo }

class ImagenNuevaPestana extends StatefulWidget {
  final Gradient gradiente;
  final bool? usarDatosTrain;
  const ImagenNuevaPestana(
      {super.key, required this.gradiente, this.usarDatosTrain = true});

  @override
  State<ImagenNuevaPestana> createState() => _ImagenNuevaPestanaState();
}

class _ImagenNuevaPestanaState extends State<ImagenNuevaPestana>
    with AutomaticKeepAliveClientMixin {
  /// Controladores de campos
  late TextEditingController clustersController;
  late TextEditingController anchoPixelesController;
  late TextEditingController altoPixelesController;

  /// Generar imagen lisa con dimensiones pedidas
  bool imagenDePrueba = false;

  /// Texto boton aceptar
  String botonAceptar = 'Generar Imagen';

  /// Imagen generada
  ui.Image? customImage;

  /// mapaDatoCluster tiene idPixel(dato) : idCluster  {0: 3, 1: 3, 2: 3, 3: 3, ... , 39274: 3, 39275: 3, 39276: 3}
  Map<int, int> mapaDatoCluster = {};

  /// mapaDatoBMU tiene idPixel(dato) : bmu  {0: 25, 1: 332, 2: 35, 3: 31, ... , 39274: 31, 39275: 40, 39276: 3}
  Map<int, int> mapaDatoBmu = {};

  /// ancho campos en barra lateral
  double anchoCampos = 300;

  /// Lista con todos los nombres de las columnas, seleccionados o no
  List<String> listaNombresColumnasOriginal = [];

  /// Lista de bool que contiene true o false dependiendo de si la columna esta seleccionada
  List<bool> listaBoolColumnasSeleccionadas = [];
  List<bool> listaBoolEtiquetasSeleccionadas = [];

  /// Lista con nombre de las columnas seleccionadas
  List<String> listaNombresColumnasSeleccionadas = [];
  List<List<dynamic>> csvData = [];
  List<List<dynamic>> csvDataOriginal = [];
  List<List<dynamic>> csvDataIdentificadores = [];
  String fileName = '';

  // Tipo de coloreado: Clustering o coloreadoContinuo
  TipoColoreado tipoColoreado = TipoColoreado.clustering;

  ///listaIdClusterColor es un mapa de {idCluster : Color}
  late Map<int, Color> listaIdClusterColor;
  final GlobalKey<ListaColorPickerState> colorPickerKey =
      GlobalKey<ListaColorPickerState>();

  late double widthPantalla;
  late double heightPantalla;

  Map<int, Color> coloresIniciales = {
    1: Colors.red,
    2: Colors.green,
    3: Colors.blue,
    4: Colors.yellow,
    5: const Color.fromARGB(255, 255, 71, 132),
    6: Colors.grey,
    7: const Color(0xFF01D0FF),
    8: const Color(0xFF0E4CA1),
    9: const Color(0xFF788231),
    10: const Color(0xFFE56FFE),
  };

  @override
  void initState() {
    clustersController = TextEditingController(text: "4");
    anchoPixelesController = TextEditingController(text: "217");
    altoPixelesController = TextEditingController(text: "181");
    listaIdClusterColor = Map.fromEntries(
        coloresIniciales.entries.take(int.parse(clustersController.text)));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final imagenNuevaProvider = context.watch<ImagenNuevaProvider>();
    final datosProvider = context.watch<DatosProvider>();
    final parametrosProvider = context.watch<ParametrosProvider>();

    widthPantalla = MediaQuery.of(context).size.width;
    heightPantalla = MediaQuery.of(context).size.height;

    return Center(
      child: Row(
        children: [
          const SizedBox(
            height: 10,
          ),

          /// COLUMNA DE CAMPOS
          _columnaLateralCampos(
              context, datosProvider, imagenNuevaProvider, parametrosProvider),
          const SizedBox(
            height: 5,
          ),

          /// BOTON DE CONFIGURACION
          customImage == null
              ? const SizedBox.shrink()
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: ElevatedButton(
                          onPressed: () {
                            showDialog<void>(
                              context: context,
                              builder: (BuildContext context) {
                                switch (tipoColoreado) {
                                  case TipoColoreado.coloreadoContinuo:
                                    return dialogColoreadoDinamico(
                                        parametrosProvider.filas,
                                        parametrosProvider.columnas,
                                        datosProvider);
                                  case TipoColoreado.clustering:
                                    return dialogClustering();
                                  default:
                                    return const AlertDialog(
                                      title:
                                          Text('Definir coloreado de imagen'),
                                    );
                                }
                              },
                            );
                          },
                          child: const Icon(Icons.settings)),
                    )
                  ],
                ),

          /// IMAGEN
          customImage == null ? const SizedBox.shrink() : _imagenWidget(),
        ],
      ),
    );
  }

  /// CONFIG DIALOG: Dialog que muestra grilla con colores usados para COLOREADO DINAMICO
  Widget dialogColoreadoDinamico(
      String filas, String columnas, DatosProvider datosProvider) {
    return AlertDialog(
      title: const Text('Colores Utilizados'),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Guardar'))
      ],
      content: Padding(
        padding: const EdgeInsets.all(30.0),
        child: SizedBox(
          height: heightPantalla * 0.7,
          width: widthPantalla * 0.6,
          child: GrillaHexagonos(
            titulo: "Colores",
            gradiente: widget.gradiente,
            dataMap: datosProvider.resultadoEntrenamiento.dataUdist,
            nombreColumnas:
                datosProvider.resultadoEntrenamiento.nombresColumnas,
            codebook: datosProvider.resultadoEntrenamiento.codebook,
            clusters: null,
            filas: datosProvider.resultadoEntrenamiento.filas,
            columnas: datosProvider.resultadoEntrenamiento.columnas,
            min: 0,
            max: 1,
            mostrarGradiente: false,
            deshabilitarBotonesHexagonos: true,
            mostrarBotonImprimir: false,
            mapaBmuColor: matrixToMap(int.parse(filas), int.parse(columnas)),
          ),
        ),
      ),
    );
  }

  /// CONFIG DIALOG: Dialog que muestra lista de colores para configurar en CLUSTERING
  Widget dialogClustering() {
    return AlertDialog(
      title: Row(
        children: [
          const Text('Colores en la imagen'),
          const SizedBox(
            width: 20.0,
          ),
          const Spacer(),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              customImage = await _generarImagenConDatos(
                  int.parse(anchoPixelesController.text),
                  int.parse(altoPixelesController.text),
                  mapaDatoCluster,
                  listaIdClusterColor);
              setState(() {});
            },
            child: const Text('Guardar'))
      ],
      content: SizedBox(
        height: heightPantalla * 0.7,
        width: widthPantalla * 0.3,
        child: Column(
          children: [
            Row(
              children: [
                /// BOTON JET
                ElevatedButton(
                    onPressed: () {
                      listaIdClusterColor = mapaConJet(listaIdClusterColor);
                      colorPickerKey.currentState!
                          .updateColors(listaIdClusterColor);
                    },
                    child: const Text('Usar jet')),
                const SizedBox(
                  width: 20.0,
                ),

                /// Boton descargar mapa
                ElevatedButton(
                    onPressed: () {
                      final valuesList = mapaDatoCluster.values.toList();
                      final valuesString = valuesList.join(' ');
                      final bytes = utf8.encode(valuesString);
                      DateTime now = DateTime.now();
                      final blob = html.Blob([bytes]);
                      final urlAux = html.Url.createObjectUrlFromBlob(blob);
                      final anchor = html.AnchorElement(href: urlAux)
                        ..setAttribute("download", "Clusters.txt")
                        ..click();
                      html.Url.revokeObjectUrl(urlAux);
                    },
                    child: const Text('Descargar')),
              ],
            ),
            const SizedBox(
              height: 20.0,
            ),
            SizedBox(
              height: heightPantalla * 0.6,
              child: ListaColorPicker(
                key: colorPickerKey,
                listaIdColor: listaIdClusterColor,
                onColorsChanged: _updatePixelGroups,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Columna que muestra imagen y boton
  // Widget _imagenWidget() {
  //   return Expanded(
  //     child: Column(
  //       children: [
  //         Padding(
  //           padding: const EdgeInsets.symmetric(vertical: 100.0),
  //           child: RawImage(image: customImage),
  //         ),
  //         ElevatedButton(
  //           onPressed: () {
  //             if (customImage != null) {
  //               _downloadImage(customImage!);
  //             }
  //           },
  //           child: const Text('Descargar Imagen'),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _imagenWidget() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Container(
              constraints: const BoxConstraints(
                maxHeight: 400.0, // Ajusta este valor según sea necesario
                maxWidth: double.infinity,
              ),
              child: InteractiveViewer(
                boundaryMargin: const EdgeInsets.all(20.0),
                minScale: 0.1,
                maxScale: 4.0,
                child: RawImage(image: customImage),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (customImage != null) {
                _downloadImage(customImage!);
              }
            },
            child: const Text('Descargar Imagen'),
          ),
        ],
      ),
    );
  }

  /// Columna lateral con campos
  Container _columnaLateralCampos(
      BuildContext context,
      DatosProvider datosProvider,
      ImagenNuevaProvider imagenNuevaProvider,
      ParametrosProvider parametrosProvider) {
    return Container(
      color: AppTheme.colorFondoGris,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// BOTON CLUSTERING / ColoreadoContinuo
            SizedBox(
              width: anchoCampos,
              child: DropdownButtonFormField(
                decoration: const InputDecoration(
                  label: Text("Tipo de coloreado"),
                ),
                value: tipoColoreado, //valor default
                items: const [
                  DropdownMenuItem(
                    value: TipoColoreado.clustering,
                    child: Text(" Clustering"),
                  ),
                  DropdownMenuItem(
                    value: TipoColoreado.coloreadoContinuo,
                    child: Text(" Coloreado Continuo "),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    customImage = null;
                    tipoColoreado = value!;
                  });
                },
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),

            if (widget.usarDatosTrain == false)

              /// La parte de seleccionar archivo la mustro si no se usan los datos de train
              Column(
                children: [
                  /// BOTON SELECCIONAR ARCHIVO
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ElevatedButton(
                      onPressed: _selectFile,
                      child: const Text(
                        'Seleccionar Archivo CSV',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),

                  /// BOTONES COLUMNAS Y ETIQUETAS
                  (csvData.isNotEmpty)
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton.icon(
                              label: const Text('Features'),
                              icon: const Icon(Icons.list),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return DialogOpciones(
                                      opciones: listaNombresColumnasOriginal,
                                      seleccionadas:
                                          listaBoolColumnasSeleccionadas,
                                      actualizarOpciones: actualizarOpciones,
                                    );
                                  },
                                );
                              },
                              //onPressed: () => {_mostrarListaOpciones(context)},
                            ),
                            TextButton.icon(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return DialogOpciones(
                                      tituloDialog:
                                          'Seleccionar columnas que son etiquetas',
                                      opciones: listaNombresColumnasOriginal,
                                      seleccionadas:
                                          listaBoolEtiquetasSeleccionadas,
                                      actualizarOpciones:
                                          actualizarOpcionesEtiquetas,
                                    );
                                  },
                                );
                              },
                              icon: const Icon(Icons.sell_outlined),
                              label: const Text('Etiquetas'),
                            )
                          ],
                        )
                      : const SizedBox.shrink(),

                  /// NOMBRE ARCHIVO / TABLA
                  (csvData.isNotEmpty)
                      ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: Text(
                              "El archivo $fileName\n cargó correctamente."),
                        )
                      : const SizedBox.shrink(),
                ],
              ),

            /// CAMPO ANCHO EN PIXELES
            SizedBox(
              width: anchoCampos,
              child: TextField(
                controller: anchoPixelesController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Ancho (en pixeles)',
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),

            /// CAMPO ALTO EN PIXELES
            SizedBox(
              width: anchoCampos,
              child: TextField(
                controller: altoPixelesController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Alto (en pixeles)',
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),

            /// CAMPO CANTIDAD DE CLUSTERS
            if (tipoColoreado == TipoColoreado.clustering)
              SizedBox(
                width: anchoCampos,
                child: TextField(
                  controller: clustersController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (value) {
                    if (customImage != null) {
                      setState(() {
                        customImage = null;
                      });
                    }
                    listaIdClusterColor = Map.fromEntries(
                        coloresIniciales.entries.take(int.parse(value)));
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Cantidad de clusters',
                  ),
                ),
              ),
            const SizedBox(
              height: 10,
            ),

            /// BOTON ACEPTAR
            ElevatedButton(
                onPressed: () async {
                  if (imagenDePrueba == true) {
                    customImage = await _generarImagenPrueba(
                      int.parse(anchoPixelesController.text),
                      int.parse(altoPixelesController.text),
                    );
                    setState(() {});
                  } else {
                    if (widget.usarDatosTrain! == true) {
                      _generarImagenConDatosTrain(
                          datosProvider,
                          imagenNuevaProvider,
                          parametrosProvider,
                          tipoColoreado);
                    } else {
                      _generarImagen(imagenNuevaProvider, datosProvider,
                          parametrosProvider, tipoColoreado);
                    }
                  }
                },
                style: AppTheme.primaryButtonStyle,
                child: imagenNuevaProvider.cargando
                    ? const CircularProgressIndicator()
                    : Text(
                        botonAceptar,
                        style: const TextStyle(fontSize: 16),
                      )),
          ],
        ),
      ),
    );
  }

  /// Update del mapa {idCluster : Color} con colores elegidos
  void _updatePixelGroups(Map<int, Color> updatedPixelGroups) {
    listaIdClusterColor = updatedPixelGroups;
  }

  /// Funcion que crea imagen
  Future<void> _generarImagen(
      ImagenNuevaProvider imagenNuevaProvider,
      DatosProvider datosProvider,
      ParametrosProvider parametrosProvider,
      TipoColoreado tipoColoreado) async {
    // Preparacion datos del csv
    List<List<dynamic>> filteredCsv = filtroColumnasSeleccionadasYEtiquetas();
    List<Map<String, String>> data = csvToData(filteredCsv);
    String jsonResult = jsonEncode(data);
    List<List<dynamic>> filteredEtiquetas = filtrarCsvData(
        listaBoolEtiquetasSeleccionadas,
        listaNombresColumnasOriginal,
        csvDataOriginal);
    List<Map<String, String>> dataEtiquetas = csvToData(filteredEtiquetas);
    String jsonResultEtiquetas = jsonEncode(dataEtiquetas);

    if (tipoColoreado == TipoColoreado.clustering) {
      /// Genera imagen a partir del clustering

      var val = datosProvider.cantDatosEntrenamiento();
      if (validarColumnasDatos(int.parse(anchoPixelesController.text),
          int.parse(altoPixelesController.text), val)) {
        /// Llama a clustering (con datos de entrenamiento) y a nuevos datos (con los nuevos datos)
        /// mapaDatoCluster tiene idPixel(dato) : idCluster  {0: 3, 1: 3, 2: 3, 3: 3, ... , 39274: 3, 39275: 3, 39276: 3}
        mapaDatoCluster = await imagenNuevaProvider.llamadaImagenDatoCluster(
            context, clustersController.text, jsonResult, jsonResultEtiquetas);

        /// listaIdClusterColor es un mapa de {idCluster : Color}
        customImage = await _generarImagenConDatos(
            int.parse(anchoPixelesController.text),
            int.parse(altoPixelesController.text),
            mapaDatoCluster,
            listaIdClusterColor);
      } else {
        mostrarDialogTexto(context, "Error de dimensiones",
            "El ancho por alto debe coincidir con la cantidad de datos de entrada");
      }
    } else {
      mapaDatoBmu = await imagenNuevaProvider.llamadaImagenDatoBMU(
          context, clustersController.text, jsonResult, jsonResultEtiquetas);

      /// Mapa {BMU : Color} (Le paso cada BMU como un cluster diferente)
      Map<int, Color> listaBMUColor = matrixToMap(
          int.parse(parametrosProvider.filas),
          int.parse(parametrosProvider.columnas));

      customImage = await _generarImagenConDatos(
          int.parse(anchoPixelesController.text),
          int.parse(altoPixelesController.text),
          mapaDatoBmu,
          listaBMUColor);
    }

    setState(() {});
  }

  // Funcion que crea imagen con los datos de TRAIN
  Future<void> _generarImagenConDatosTrain(
      DatosProvider datosProvider,
      ImagenNuevaProvider imagenNuevaProvider,
      ParametrosProvider parametrosProvider,
      TipoColoreado tipoColoreado) async {
    if (tipoColoreado == TipoColoreado.clustering) {
      /// Llama a clustering (con datos de entrenamiento) y a nuevos datos (con los nuevos datos)
      /// listaIdClusterColor es un mapa de {idCluster : Color}
      var val = datosProvider.cantDatosEntrenamiento();
      if (validarColumnasDatos(int.parse(anchoPixelesController.text),
          int.parse(altoPixelesController.text), val)) {
        /// mapaDatoCluster tiene idPixel(dato) : idCluster  {0: 3, 1: 3, 2: 3, 3: 3, ... , 39274: 3, 39275: 3, 39276: 3}
        mapaDatoCluster = await imagenNuevaProvider.datoClusterImagenOriginal(
            context, clustersController.text);

        /// Genera imagen a partir del clustering
        customImage = await _generarImagenConDatos(
            int.parse(anchoPixelesController.text),
            int.parse(altoPixelesController.text),
            mapaDatoCluster,
            listaIdClusterColor);
      } else {
        mostrarDialogTexto(context, "Error de dimensiones",
            "El ancho por alto debe coincidir con la cantidad de datos de entrada");
      }
    } else {
      mapaDatoBmu = await imagenNuevaProvider.datoBmuImagenOriginal(
          context, clustersController.text);

      /// Mapa {BMU : Color} (Le paso cada BMU como un cluster diferente)
      Map<int, Color> listaBMUColor = matrixToMap(
          int.parse(parametrosProvider.filas),
          int.parse(parametrosProvider.columnas));

      customImage = await _generarImagenConDatos(
          int.parse(anchoPixelesController.text),
          int.parse(altoPixelesController.text),
          mapaDatoBmu,
          listaBMUColor);
    }

    setState(() {});
  }

  void actualizarOpciones(List<bool> opcionesSeleccionadasBool) {
    listaBoolColumnasSeleccionadas = opcionesSeleccionadasBool;

    // A partir de los datos originales y las col seleccionadas, devuelve datos solo con col seleccionadas
    List<List<dynamic>> filteredData = filtrarCsvData(opcionesSeleccionadasBool,
        listaNombresColumnasOriginal, csvDataOriginal);

    // Armo lista de nombres con columnas seleccionadas
    List<String> seleccionadasList = [];
    for (int i = 0; i < listaNombresColumnasOriginal.length; i++) {
      if (listaBoolColumnasSeleccionadas[i]) {
        seleccionadasList.add(listaNombresColumnasOriginal[i]);
      }
    }

    setState(() {
      listaNombresColumnasSeleccionadas = seleccionadasList;
      csvData = filteredData;
    });
  }

  void actualizarOpcionesEtiquetas(List<bool> opcionesSeleccionadasBool) {
    listaBoolEtiquetasSeleccionadas = opcionesSeleccionadasBool;

    setState(() {});
  }

  void _loadCSVData(FilePickerResult result) async {
    Uint8List? fileBytes = result.files.first.bytes;
    fileName = result.files.first.name;

    if (fileName.endsWith('.csv')) {
      String fileContent = utf8.decode(fileBytes!);
      List<List<dynamic>> csvTable =
          const CsvToListConverter().convert(fileContent);

      setState(() {
        csvDataOriginal = csvTable;
        csvData = csvTable;
        listaNombresColumnasOriginal = csvData[0][0].toString().split(';');
        listaNombresColumnasSeleccionadas = csvData[0][0].toString().split(';');
        // Inicializo lista de bools
        listaBoolColumnasSeleccionadas = [];
        for (int i = 0; i < listaNombresColumnasOriginal.length; i++) {
          listaBoolColumnasSeleccionadas.add(true);
        }
        listaBoolEtiquetasSeleccionadas = [];
        for (int i = 0; i < listaNombresColumnasOriginal.length; i++) {
          listaBoolEtiquetasSeleccionadas.add(false);
        }

        csvDataIdentificadores.add(['Dato']);
        for (int identificador_dato = 1;
            identificador_dato < csvData.length;
            identificador_dato++) {
          csvDataIdentificadores.add([identificador_dato]);
        }

        // Para probar !!!!! TODO: BORRAR
        listaBoolEtiquetasSeleccionadas[0] = true;
        // listaBoolEtiquetasSeleccionadas[1] = true;
      });
    } else {
      mostrarDialogTexto(
          context, 'Archivo Invalido', 'Debe seleccionar un archivo CSV.');
    }
  }

  void _selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      _loadCSVData(result);
    }
  }

  // junto ambas listas de bool y filtro csv data origin //TODO: USAR LA MISMA QUE HOME PAGE
  List<List<dynamic>> filtroColumnasSeleccionadasYEtiquetas() {
    List<bool> columnasATenerEnCuenta = [];
    for (int index = 0; index < listaNombresColumnasOriginal.length; index++) {
      if (listaBoolEtiquetasSeleccionadas[index] == true ||
          listaBoolColumnasSeleccionadas[index] == false) {
        columnasATenerEnCuenta.add(false);
      } else {
        columnasATenerEnCuenta.add(true);
      }
    }
    List<List<dynamic>> filteredData = filtrarCsvData(
        columnasATenerEnCuenta, listaNombresColumnasOriginal, csvDataOriginal);
    return filteredData;
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

/// Generacion de la imagen
Future<ui.Image> _generarImagenConDatos(int widthImagen, int heightImagen,
    Map<int, int> mapaDatoCluster, Map<int, Color> pixelGroups) async {
  /// pixelGroups es un mapa de {idCluster : Color}
  /// mapaDatoCluster tiene idPixel(dato) : idCluster  {0: 3, 1: 3, 2: 3, 3: 3, ... , 39274: 3, 39275: 3, 39276: 3}
  /// Me quedo con los id de los clusters (cada posicion es un pixel) [3, 3, 3, ....., 3, 3, 3]
  List<int> pixelIds = List<int>.from(mapaDatoCluster.values);

  //Map<int, Color> pixelGroups = generatePixelGroups(pixelIds); // Para que el fondo sea negro y lo demas de gradiente

  /// Crea un buffer para almacenar los datos de los píxeles
  final Uint8List pixels = Uint8List(widthImagen * heightImagen * 4);

  for (int y = 0; y < heightImagen; y++) {
    for (int x = 0; x < widthImagen; x++) {
      /// id del pixel
      int index = y * widthImagen + x;

      /// Obtengo el color con el id de cluster
      Color color = pixelGroups[pixelIds[index]]!;

      /// Lleno el buffer con los datos del color
      int offset = index * 4;
      pixels[offset] = color.red;
      pixels[offset + 1] = color.green;
      pixels[offset + 2] = color.blue;
      pixels[offset + 3] = color.alpha;
    }
  }

  /// Genero imagen
  final ui.ImmutableBuffer buffer =
      await ui.ImmutableBuffer.fromUint8List(pixels);
  final ui.ImageDescriptor descriptor = ui.ImageDescriptor.raw(
    buffer,
    width: widthImagen,
    height: heightImagen,
    pixelFormat: ui.PixelFormat.rgba8888,
  );
  final ui.Codec codec = await descriptor.instantiateCodec();
  final ui.FrameInfo frameInfo = await codec.getNextFrame();

  return frameInfo.image;
}

/// Generar datos de la imagen en formato PNG
Future<Uint8List> _generatePngData(ui.Image image) async {
  final ByteData? byteData =
      await image.toByteData(format: ui.ImageByteFormat.png);
  if (byteData != null) {
    return byteData.buffer.asUint8List();
  }
  throw Exception('Unable to generate PNG data');
}

/// Descargar la imagen
Future<void> _downloadImage(ui.Image image) async {
  final Uint8List pngBytes = await _generatePngData(image);

  final blob = html.Blob([pngBytes], 'image/png');
  final url = html.Url.createObjectUrlFromBlob(blob);
  var now = DateTime.now();
  final anchor = html.AnchorElement(href: url)
    ..setAttribute("download", "Imagen-$now.png")
    ..click();
  html.Url.revokeObjectUrl(url);
}

/// Funcion para que el color mayoritario sea negro y los demas dependan de un gradiente
// Map<int, Color> generatePixelGroups(List<int> pixelIds) {
//   // Contar la frecuencia de cada pixelId
//   Map<int, int> frequencyMap = {};
//   for (int id in pixelIds) {
//     if (!frequencyMap.containsKey(id)) {
//       frequencyMap[id] = 0;
//     }
//     frequencyMap[id] = frequencyMap[id]! + 1;
//   }

//   // Ordenar los pixelIds por frecuencia
//   List<int> sortedPixelIds = frequencyMap.keys.toList()
//     ..sort((a, b) => frequencyMap[b]!.compareTo(frequencyMap[a]!));

//   List<Color> gradientColors = [
//     Colors.red,
//     Colors.orange,
//     Colors.yellow,
//     Colors.green,
//     Colors.blue,
//     Colors.indigo,
//     Colors.purple,
//     Colors.pink,
//     Colors.teal,
//     Colors.cyan,
//     Colors.lime,
//     Colors.amber,
//     Colors.brown,
//     Colors.grey,
//     Colors.lightBlue,
//     Colors.lightGreen,
//   ];

//   // Asegurar que haya suficientes colores en el gradiente
//   while (gradientColors.length < sortedPixelIds.length - 1) {
//     gradientColors.addAll(gradientColors);
//   }

//   // Crear el Map<int, Color> asignando colores a cada pixelId
//   Map<int, Color> pixelGroups = {};
//   for (int i = 0; i < sortedPixelIds.length; i++) {
//     int pixelId = sortedPixelIds[i];
//     pixelGroups[pixelId] = (i == 0) ? Colors.black : gradientColors[i - 1];
//   }

//   return pixelGroups;
// }

/// Devuelve mapa del mismo tamaño pero con colores usando JET
Map<int, Color> mapaConJet(Map<int, Color> listaIdClusterColor) {
  Color jet(double value) {
    assert(0.0 <= value && value <= 1.0);

    double r, g, b;

    if (value < 0.25) {
      r = 0;
      g = 4 * value;
      b = 1;
    } else if (value < 0.5) {
      r = 0;
      g = 1;
      b = 1 + 4 * (0.25 - value);
    } else if (value < 0.75) {
      r = 4 * (value - 0.5);
      g = 1;
      b = 0;
    } else {
      r = 1;
      g = 1 + 4 * (0.75 - value);
      b = 0;
    }

    return Color.fromARGB(
        255, (r * 255).toInt(), (g * 255).toInt(), (b * 255).toInt());
  }

  int cantidadClusters = listaIdClusterColor.length;
  List<double> valores = List<double>.generate(
      cantidadClusters, (index) => index / (cantidadClusters - 1));

  int i = 0;
  listaIdClusterColor.updateAll((key, value) {
    return jet(valores[i++]);
  });

  return listaIdClusterColor;
}

/// Imagen de prueba para probar dimensiones
Future<ui.Image> _generarImagenPrueba(int widthImagen, int heightImagen) async {
  final Uint8List pixels = Uint8List(widthImagen * heightImagen * 4);

  for (int y = 0; y < heightImagen; y++) {
    for (int x = 0; x < widthImagen; x++) {
      /// id del pixel
      int index = y * widthImagen + x;

      /// Obtengo el color con el id de cluster
      Color color = (x + y) % 2 == 0 ? Colors.red : Colors.blue;

      /// Lleno el buffer con los datos del color
      int offset = index * 4;
      pixels[offset] = color.red;
      pixels[offset + 1] = color.green;
      pixels[offset + 2] = color.blue;
      pixels[offset + 3] = color.alpha;
    }
  }

  /// Genero imagen
  final ui.ImmutableBuffer buffer =
      await ui.ImmutableBuffer.fromUint8List(pixels);
  final ui.ImageDescriptor descriptor = ui.ImageDescriptor.raw(
    buffer,
    width: widthImagen,
    height: heightImagen,
    pixelFormat: ui.PixelFormat.rgba8888,
  );
  final ui.Codec codec = await descriptor.instantiateCodec();
  final ui.FrameInfo frameInfo = await codec.getNextFrame();

  return frameInfo.image;
}
