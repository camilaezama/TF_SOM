import 'dart:ui' as ui;

import 'package:TF_SOM_UNMdP/config/tema.dart';
import 'package:TF_SOM_UNMdP/providers/datos_provider.dart';
import 'package:TF_SOM_UNMdP/providers/imagen_provider.dart';
import 'package:TF_SOM_UNMdP/utils/mostrar_dialog_texto.dart';
import 'package:TF_SOM_UNMdP/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ImagenPestana extends StatefulWidget {
  final Gradient gradiente;
  const ImagenPestana({super.key, required this.gradiente});

  @override
  State<ImagenPestana> createState() => _ImagenPestanaState();
}

class _ImagenPestanaState extends State<ImagenPestana> {
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

  @override
  void initState() {
    clustersController = TextEditingController(text: "4");
    anchoPixelesController = TextEditingController(text: "217");
    altoPixelesController = TextEditingController(text: "181");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final imagenProvider = context.watch<ImagenProvider>();
    final datosProvider = context.watch<DatosProvider>();
    return Center(
      child: Row(
        children: [
          const SizedBox(
            height: 10,
          ),

          /// COLUMNA DE CAMPOS
          _columnaLateralCampos(context, imagenProvider, datosProvider),
          const SizedBox(
            height: 5,
          ),

          customImage == null ? const SizedBox.shrink() : _imagenWidget(),
        ],
      ),
    );
  }

  /// Funcion que crea imagen
  Future<void> _generarImagen(
      ImagenProvider imagenProvider, DatosProvider datosProvider) async {
    /// Llama a clustering (con datos de entrenamiento)
    /// mapaDatoCluster tiene idPixel(dato) : idCluster  {0: 3, 1: 3, 2: 3, 3: 3, ... , 39274: 3, 39275: 3, 39276: 3}
    mapaDatoCluster =
        await imagenProvider.llamadaImagen(context, clustersController.text);

    /// Genera imagen a partir del clustering
    var val = datosProvider.cantDatosEntrenamiento();
    if (validarColumnasDatos(int.parse(anchoPixelesController.text),
        int.parse(altoPixelesController.text), val)) {
      customImage = await _generarImagenConDatos(
          int.parse(anchoPixelesController.text),
          int.parse(altoPixelesController.text),
          mapaDatoCluster);

      setState(() {});
    } else {
      mostrarDialogTexto(context, "Error de dimensiones",
          "El ancho por alto debe coincidir con la cantidad de datos de entrada");
    }
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
  Container _columnaLateralCampos(BuildContext context,
      ImagenProvider imagenProvider, DatosProvider datosProvider) {
    return Container(
      color: AppTheme.colorFondoGris,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
                  _generarImagen(imagenProvider, datosProvider);
                },
                style: AppTheme.primaryButtonStyle,
                child: imagenProvider.cargando
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
