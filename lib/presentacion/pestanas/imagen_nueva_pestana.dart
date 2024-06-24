import 'dart:convert';
import 'dart:ui' as ui;

import 'package:TF_SOM_UNMdP/config/tema.dart';
import 'package:TF_SOM_UNMdP/presentacion/shared-widgets/dialogs/seleccionar_opciones_dialog.dart';
import 'package:TF_SOM_UNMdP/presentacion/shared-widgets/tabla_datos.dart';
import 'package:TF_SOM_UNMdP/providers/imagen_nueva_provider.dart';
import 'package:TF_SOM_UNMdP/utils/csv_to_data.dart';
import 'package:TF_SOM_UNMdP/utils/mostrar_dialog_texto.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';

class ImagenNuevaPestana extends StatefulWidget {
  final Gradient gradiente;
  const ImagenNuevaPestana({super.key, required this.gradiente});

  @override
  State<ImagenNuevaPestana> createState() => _ImagenNuevaPestanaState();
}

class _ImagenNuevaPestanaState extends State<ImagenNuevaPestana> {
  /// Controladores de campos
  late TextEditingController clustersController;
  late TextEditingController anchoPixelesController;
  late TextEditingController altoPixelesController;

  /// Texto boton aceptar
  String botonAceptar = 'Generar Imagen';

  /// Imagen generada
  ui.Image? customImage;

  /// mapaDatoCluster tiene idPixel(dato) : idCluster  {0: 3, 1: 3, 2: 3, 3: 3, ... , 39274: 3, 39275: 3, 39276: 3}
  Map<int, int> mapaDatoCluster = {};

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

  @override
  void initState() {
    clustersController = TextEditingController(text: "4");
    anchoPixelesController = TextEditingController(text: "217");
    altoPixelesController = TextEditingController(text: "181");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final imagenNuevaProvider = context.watch<ImagenNuevaProvider>();

    return Center(
      child: Row(
        children: [
          const SizedBox(
            height: 10,
          ),

          /// COLUMNA DE CAMPOS
          _columnaLateralCampos(context, imagenNuevaProvider),
          const SizedBox(
            height: 5,
          ),

          customImage == null ? const SizedBox.shrink() : _imagenWidget(),
        ],
      ),
    );
  }

  /// Columna que muestra imagen y boton
  Widget _imagenWidget() {
    return Expanded(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 100.0),
            child: RawImage(image: customImage),
          ),
          const ElevatedButton(
            onPressed: _downloadImage,
            child: Text('Descargar Imagen (TO DO)'),
          ),
        ],
      ),
    );
  }

  /// Columna lateral con campos
  Container _columnaLateralCampos(
      BuildContext context, ImagenNuevaProvider imagenNuevaProvider) {
    return Container(
      color: AppTheme.colorFondoGris,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
                                seleccionadas: listaBoolColumnasSeleccionadas,
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
                                seleccionadas: listaBoolEtiquetasSeleccionadas,
                                actualizarOpciones: actualizarOpcionesEtiquetas,
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
                ? (csvData.length > 100)
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Text(fileName),
                      )
                    : TablaDatos(
                        csvData: csvData,
                        columnNames: listaNombresColumnasSeleccionadas,
                      )
                : const SizedBox.shrink(),

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
            SizedBox(
              width: anchoCampos,
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
              height: 10,
            ),

            /// BOTON ACEPTAR
            ElevatedButton(
                onPressed: () async {
                  _generarImagen(imagenNuevaProvider);
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

  /// Funcion que crea imagen
  Future<void> _generarImagen(ImagenNuevaProvider imagenNuevaProvider) async {

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

    /// Llama a clustering (con datos de entrenamiento) y a nuevos datos (con los nuevos datos)
    /// mapaDatoCluster tiene idPixel(dato) : idCluster  {0: 3, 1: 3, 2: 3, 3: 3, ... , 39274: 3, 39275: 3, 39276: 3}
    mapaDatoCluster =
        await imagenNuevaProvider.llamadaImagen(context, clustersController.text, jsonResult, jsonResultEtiquetas);

    /// Genera imagen a partir del clustering
    customImage = await _generarImagenConDatos(
        int.parse(anchoPixelesController.text),
        int.parse(altoPixelesController.text),
        mapaDatoCluster);

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

    _loadCSVData(result!);
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



}

Future<ui.Image> _generarImagenConDatos(
    int widthImagen, int heightImagen, Map<int, int> mapaDatoCluster) async {
  /// mapaDatoCluster tiene idPixel(dato) : idCluster  {0: 3, 1: 3, 2: 3, 3: 3, ... , 39274: 3, 39275: 3, 39276: 3}
  /// Me quedo con los id de los clusters (cada posicion es un pixel) [3, 3, 3, ....., 3, 3, 3]
  List<int> pixelIds = List<int>.from(mapaDatoCluster.values);

  /// Mapa de idCluster : Color
  Map<int, Color> pixelGroups = {
    1: Colors.red,
    2: Colors.green,
    3: Colors.blue,
    4: Colors.yellow,
    5: const ui.Color.fromARGB(255, 255, 71, 132),
    6: Colors.grey,
    7: const Color(0xFF01D0FF),
    8: const Color(0xFF0E4CA1),
    9: const Color(0xFF788231),
    10: const Color(0xFFE56FFE),
  };
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

Future<void> _downloadImage() async {
  ///TODO: Que se pueda descargar imagen generada
}

/// Funcion para que el color mayoritario sea negro y los demas dependan de un gradiente
Map<int, Color> generatePixelGroups(List<int> pixelIds) {
  // Contar la frecuencia de cada pixelId
  Map<int, int> frequencyMap = {};
  for (int id in pixelIds) {
    if (!frequencyMap.containsKey(id)) {
      frequencyMap[id] = 0;
    }
    frequencyMap[id] = frequencyMap[id]! + 1;
  }

  // Ordenar los pixelIds por frecuencia
  List<int> sortedPixelIds = frequencyMap.keys.toList()
    ..sort((a, b) => frequencyMap[b]!.compareTo(frequencyMap[a]!));

  List<Color> gradientColors = [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.indigo,
    Colors.purple,
    Colors.pink,
    Colors.teal,
    Colors.cyan,
    Colors.lime,
    Colors.amber,
    Colors.brown,
    Colors.grey,
    Colors.lightBlue,
    Colors.lightGreen,
  ];
  
  // Asegurar que haya suficientes colores en el gradiente
  while (gradientColors.length < sortedPixelIds.length - 1) {
    gradientColors.addAll(gradientColors);
  }

  // Crear el Map<int, Color> asignando colores a cada pixelId
  Map<int, Color> pixelGroups = {};
  for (int i = 0; i < sortedPixelIds.length; i++) {
    int pixelId = sortedPixelIds[i];
    pixelGroups[pixelId] = (i == 0) ? Colors.black : gradientColors[i - 1];
  }

  return pixelGroups;
}
