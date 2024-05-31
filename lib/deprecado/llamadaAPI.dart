  // void _llamadaAPI() async {
  //   //Navigator.pushNamed(context, '/grillas');

  //   final parametrosProvider = context.read<ParametrosProvider>();

  //   final datosProvider = context.read<DatosProvider>();

  //   if (csvData.isNotEmpty) {
  //     ByteData byteData = csvToByteData(csvData);

  //     String content = String.fromCharCodes(byteData.buffer.asUint8List());

  //     // Parsear el contenido CSV con el delimitador ';'
  //     List<List<dynamic>> rows =
  //         const CsvToListConverter(eol: '\n', fieldDelimiter: ';')
  //             .convert(content);
  //     List<Map<String, String>> result = convertRowsToMap(rows);

  //     String jsonResult = jsonEncode(result);

  //     try {
  //       String tipoLlamada = "bmu";
  //       var url = Uri.parse('http://localhost:7777/$tipoLlamada');

  //       final parametros = <String, dynamic>{
  //         'filas': parametrosProvider.filas != "" ? parametrosProvider.filas : 24,
  //         'columnas': parametrosProvider.columnas != ""
  //             ? parametrosProvider.columnas
  //             : 31, //TODO IMPORTANTE VALIDAR QUE LA ENTRADA DEL USUARIO SEA NUMEROS!!
  //         'vecindad': parametrosProvider.funcionVecindad,
  //         'inicializacion': parametrosProvider.inicializacion,
  //         'iteraciones': parametrosProvider.itera != ""
  //             ? parametrosProvider.itera
  //             : 200, //IMPORTANTE VALIDAR QUE LA ENTRADA DEL USUARIO SEA NUMEROS!!
  //         'normalizacion': parametrosProvider.normalizacion,
  //         'factorEntrenamiento': parametrosProvider.factorEntrenamiento != ""
  //             ? parametrosProvider.factorEntrenamiento
  //             : 2 //IMPORTANTE VALIDAR QUE LA ENTRADA DEL USUARIO SEA NUMEROS!!
  //       };

  //       // final parametros = <String, dynamic>{
  //       //   'filas': filasController.text != "" ? filasController.text : 24,
  //       //   'columnas': columnasController.text != ""
  //       //       ? columnasController.text
  //       //       : 31, //TODO IMPORTANTE VALIDAR QUE LA ENTRADA DEL USUARIO SEA NUMEROS!!
  //       //   'vecindad': funcionVecindad,
  //       //   'inicializacion': inicializacion,
  //       //   'iteraciones': iteracontroller.text != ""
  //       //       ? iteracontroller.text
  //       //       : 200, //IMPORTANTE VALIDAR QUE LA ENTRADA DEL USUARIO SEA NUMEROS!!
  //       //   'normalizacion': normalizacion,
  //       //   'factorEntrenamiento': factorEntrenamientoController.text != ""
  //       //       ? factorEntrenamientoController.text
  //       //       : 2 //IMPORTANTE VALIDAR QUE LA ENTRADA DEL USUARIO SEA NUMEROS!!
  //       // };

  //       setState(() {
  //         //boton = "Cargando...";
  //         cargando = true;
  //       });
  //       // var response = await http.post(url,
  //       //     headers: {'Accept': '/*'}, body: jsonResult);
  //       var response = await http.post(url,
  //           headers: {'Accept': '/*'},
  //           body: jsonEncode({
  //             "datos": jsonResult,
  //             "tipo": tipoLlamada,
  //             "params": parametros
  //           }));

  //       // print('Response status: ${response.statusCode}');
  //       //print('Response body: ${response.body}');

  //       // Map<String, dynamic> jsonList = json.decode(response.body);
  //       // Map<String,Map<String, String>> mapaRta = Map<String,Map<String, String>>.from(jsonList);

  //       // Decodificar la cadena JSON
  //       Map<String, dynamic> decodedJson = json.decode(response.body);

  //       Map<String, dynamic> NeuronsJSON = decodedJson["Neurons"];
  //       List<dynamic> Codebook = decodedJson["Codebook"];
  //       List<dynamic> UmatJSON = decodedJson["UMat"];

  //       print(Codebook);

  //       /// Procesamiento de datos para Hits
  //       Map<String, dynamic> HitsJSON = decodedJson["Hits"];
  //       Map<int, int> hitsMap = Map<int, int>.from(
  //           HitsJSON.map((key, value) => MapEntry(int.parse(key), value)));

  //       /// Procesamiento de datos para UMat
  //       List<List<double>> lista = [];
  //       UmatJSON.forEach((element) {
  //         List<double> elementt = [];
  //         element.forEach((e) {
  //           elementt.add(double.parse(e.toString()));
  //         });
  //         lista.add(elementt);
  //       });

  //       Map<String, String> dataMapUmat = {};
  //       lista.forEach((element) {
  //         dataMapUmat[element[0].toString()] = element[1].toString();
  //       });
  //       //Map<String, dynamic> umatJson = decodedJson["umat"];
  //       /// Procesamiento de datos para UMat
  //       lista = [];
  //       Codebook.forEach((element) {
  //         List<double> elementt = [];
  //         element.forEach((e) {
  //           elementt.add(double.parse(e.toString()));
  //         });
  //         lista.add(elementt);
  //       });

  //       Map<String, Object> respuesta = {};

  //       /// Procesamiento de datos para BMUs
  //       Map<String, Map<String, String>> mapaRta = {};

  //       // Iterar sobre las claves externas del primer nivel
  //       for (String outerKey in NeuronsJSON.keys) {
  //         // Obtener el valor correspondiente a la clave externa
  //         Map<String, dynamic> innerMap = NeuronsJSON[outerKey];

  //         // Convertir el mapa interno a Map<String, String>
  //         Map<String, String> innerMapString = {};
  //         innerMap.forEach((key, value) {
  //           if (tipoLlamada == "json") {
  //             int keyInt = int.parse(key) + 1;
  //             String keyy = keyInt.toString();
  //             innerMapString[keyy] = value.toString();
  //           } else {
  //             innerMapString[key] = value.toString();
  //           }
  //         });

  //         // Agregar el par clave-valor al mapa final
  //         mapaRta[outerKey] = innerMapString;
  //       }



  //       respuesta["respuestaBMU"] = mapaRta;
  //       respuesta["respuestaUmat"] = dataMapUmat;
  //       respuesta["parametros"] = parametros;
  //       respuesta["respuestaHits"] = hitsMap;
  //       respuesta["codebook"] = lista;

  //       List<String> nombresColumnas = [];
  //       List<String> keys = mapaRta.keys.toList();
  //       for (var i = 7; i < keys.length; i++) {
  //         nombresColumnas.add(keys[i]);
  //       }
  //       respuesta["nombrescolumnas"] = nombresColumnas;

  //       datosProvider.updateDatos(
  //         dataUdist: mapaRta["Udist"],
  //         mapaRtaUmat: dataMapUmat,
  //         codebook: lista,
  //         filas: int.parse(parametros["filas"]),
  //         columnas: int.parse(parametros["columnas"]),
  //         nombresColumnas: nombresColumnas,
  //         hitsMap: hitsMap
  //       );

  //       //respuesta["codebook"] =
  //       setState(() {
  //         //boton = 'La respuesta fue: ${response.body}';
  //         Navigator.pushNamed(
  //           context,
  //           '/grillas',
  //           arguments: respuesta,
  //         );
  //         cargando = false;
  //       });
  //     } catch (e) {
  //       showDialog<void>(
  //         context: context,
  //         builder: (BuildContext context) {
  //           return AlertDialog(
  //             title: const Text('Error'),
  //             content:
  //                 Text('Error en la  llamada de servicio: ' + e.toString()),
  //             actions: [
  //               TextButton(
  //                 onPressed: () {
  //                   Navigator.of(context).pop(); // Cerrar el cuadro de diálogo
  //                 },
  //                 child: const Text('Cerrar'),
  //               ),
  //             ],
  //           );
  //         },
  //       );
  //       setState(() {
  //         cargando = false;
  //         botonAceptar = "Aceptar";
  //       });
  //     }
  //   } else {
  //     showDialog<void>(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           title: const Text('Error al cargar'),
  //           content: const Text('Debe seleccionar un archivo.'),
  //           actions: [
  //             TextButton(
  //               onPressed: () {
  //                 Navigator.of(context).pop(); // Cerrar el cuadro de diálogo
  //               },
  //               child: const Text('Cerrar'),
  //             ),
  //           ],
  //         );
  //       },
  //     );
  //   }
  // }