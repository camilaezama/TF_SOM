  // Widget _buildWidgetUMat() {
  //   Gradient gradiente = const LinearGradient(
  //     colors: [
  //       Color.fromARGB(255, 8, 82, 143),
  //       Colors.blue,
  //       Colors.green,
  //       Colors.yellow,
  //       Colors.orange,
  //       Colors.red,
  //     ],
  //     stops: [0.0, 0.2, 0.4, 0.6, 0.8, 1.0],
  //   );

  //   return GrillaHexagonos(
  //       titulo: "UMat",
  //       gradiente: gradiente,
  //       dataMap: mapaRtaUmat,
  //       nombreColumnas: nombresColumnas,
  //       codebook: codebook,
  //       filas: filas * 2,
  //       columnas: columnas * 2,
  //       paddingEntreHexagonos: 0.2);
  // }

  // Widget _buildWidgetClusters() {
  //   return Center(
  //     child: Column(
  //       children: [
  //         const SizedBox(
  //           height: 25,
  //         ),
  //         SizedBox(
  //           width: 250, // Set the desired width here
  //           child: TextField(
  //             controller: clustersController,
  //             keyboardType: TextInputType.number,
  //             inputFormatters: [FilteringTextInputFormatter.digitsOnly],
  //             decoration: const InputDecoration(
  //               border: OutlineInputBorder(),
  //               labelText: 'Cantidad de clusters',
  //             ),
  //           ),
  //         ),
  //         const SizedBox(
  //           height: 25,
  //         ),
  //         ElevatedButton(
  //             onPressed: _llamadaClustering,
  //             style: ElevatedButton.styleFrom(
  //               backgroundColor: Colors.blue,
  //               foregroundColor: Colors.white,
  //               padding: const EdgeInsets.symmetric(horizontal: 16),
  //               shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(8.0),
  //               ),
  //             ),
  //             child: cargando
  //                 ? const CircularProgressIndicator()
  //                 : Text(
  //                     botonAceptar,
  //                     style: const TextStyle(fontSize: 16),
  //                   )),
  //         mostarGrilla
  //             ? Expanded(
  //                 child: GrillaHexagonos(
  //                     dataMap: dataUdist,
  //                     filas: filas,
  //                     nombreColumnas: nombresColumnas,
  //                     clusters: mapaRtaClusters,
  //                     codebook: codebook,
  //                     columnas: columnas,
  //                     titulo: "Clustering"),
  //               )
  //             : const Text("")
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildWidgetHits() {
  //   Gradient gradiente = const LinearGradient(
  //     colors: [
  //       Color.fromARGB(255, 8, 82, 143),
  //       Colors.blue,
  //       Colors.green,
  //       Colors.yellow,
  //       Colors.orange,
  //       Colors.red,
  //     ],
  //     stops: [0.0, 0.2, 0.4, 0.6, 0.8, 1.0],
  //   );
  //   return GrillaHexagonos(
  //     titulo: "Hits",
  //     gradiente: gradiente,
  //     codebook: codebook,
  //     nombreColumnas: nombresColumnas,
  //     dataMap: dataUdist,
  //     filas: filas,
  //     columnas: columnas,
  //     hits: true,
  //     hitsMap: hitsMap,
  //   );
  // }

  // Widget _buildWidgetBMUs() {
  //   Gradient gradiente = const LinearGradient(
  //     colors: [
  //       Color.fromARGB(255, 8, 82, 143),
  //       Colors.blue,
  //       Colors.green,
  //       Colors.yellow,
  //       Colors.orange,
  //       Colors.red,
  //     ],
  //     stops: [0.0, 0.2, 0.4, 0.6, 0.8, 1.0],
  //   );
  //   return GrillaHexagonos(
  //       titulo: "BMU",
  //       gradiente: gradiente,
  //       dataMap: dataUdist,
  //       nombreColumnas: nombresColumnas,
  //       codebook: codebook,
  //       clusters: null,
  //       filas: filas,
  //       columnas: columnas);
  // }

/*
  Widget _buildWidgetGrillaComponentes(Map<String, dynamic> mapaRta) {
    List<String> options = [];
    options.add("Seleccione");
    //Ignora las primeras 6 (i = 7) porque son BMU, Udist, etc etc, me quedo con las que son componentes
    List<String> keys = mapaRta.keys.toList();
    for (var i = 7; i < keys.length; i++) {
      options.add(keys[i]);
    }
    Gradient gradiente = const LinearGradient(
      colors: [
        Color.fromARGB(255, 8, 82, 143),
        Colors.blue,
        Colors.green,
        Colors.yellow,
        Colors.orange,
        Colors.red,
      ],
      stops: [0.0, 0.2, 0.4, 0.6, 0.8, 1.0],
    );
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Elija la componente a mostrar: '),
        const SizedBox(width: 5),
        GenericDropdownMenu(
          listaOpciones: options,
          onSelected: (String selectedValue) {
            // Step 3: Update dataComponente and trigger rebuild
            setState(() {
              selectedComponente = selectedValue;
              dataComponente = mapaRta[selectedValue] ?? {};
              title = selectedValue;
            });
          },
        ),
        Expanded(
            child: GrillaHexagonos(
                titulo: title,
                gradiente: gradiente,
                dataMap: dataComponente,
                filas: filas,
                columnas: columnas)),
      ],
    ));
  }
*/
//   void _llamadaClustering() async {
//     try {
//       String TIPO_LLAMADA = "clusters";
//       var url = Uri.parse('http://localhost:7777' + '/' + TIPO_LLAMADA);

//       final parametros = <String, dynamic>{
//         'filas': filas != "" ? filas : 24,
//         'columnas': columnas != "" ? columnas : 31,
//         'cantidadClusters':
//             clustersController.text != "" ? clustersController.text : 10
//       };

//       var response = await http.post(url,
//           headers: {'Accept': '/*'},
//           body: jsonEncode(
//               {"datos": codebook, "tipo": TIPO_LLAMADA, "params": parametros}));
//       List<dynamic> decodedJson = json.decode(response.body);
//       List<List<int>> rtaClusters = decodedJson.map((dynamic item) {
//         if (item is List<dynamic>) {
//           return item.map((dynamic subItem) => subItem as int).toList();
//         } else {
//           throw Exception('Invalid item in list');
//         }
//       }).toList();
//       setState(() {
//         mapaRtaClusters = rtaClusters;
//         mostarGrilla = true;
//         cargando = false;
//       });
//     } catch (e) {
//       setState(() {
//         cargando = false;
//         botonAceptar = "Aceptar";
//       });
//     }
//   }