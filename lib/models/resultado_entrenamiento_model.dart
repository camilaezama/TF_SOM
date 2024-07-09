class ResultadoEntrenamientoModel {
  Map<String, Map<String, String>> mapaRta = {};
  Map<String, String> dataUdist = {};
  Map<String, String> mapaRtaUmat = {};
  List<List<double>> codebook = [];
  int filas = 0;
  int columnas = 0;
  List<String> nombresColumnas = [];
  List<Map<String, dynamic>> etiquetas = [];
  Map<int, int> hitsMap = {};
  List<dynamic> datos = [];
  Map<String, String> parametros = {};
  Map<String, String> errores = {};

  ResultadoEntrenamientoModel(
      {Map<String, Map<String, String>>? mapaRta,
      Map<String, String>? dataUdist,
      Map<String, String>? mapaRtaUmat,
      List<List<double>>? codebook,
      int? filas,
      int? columnas,
      List<String>? nombresColumnas,
      List<Map<String, dynamic>>? etiquetas,
      Map<int, int>? hitsMap,
      List<dynamic>? datos,
      Map<String, String>? parametros,
      Map<String, String>? errores}) {
    if (mapaRta != null) this.mapaRta = mapaRta;
    if (dataUdist != null) this.dataUdist = dataUdist;
    if (mapaRtaUmat != null) this.mapaRtaUmat = mapaRtaUmat;
    if (codebook != null) this.codebook = codebook;
    if (etiquetas != null) this.etiquetas = etiquetas;
    if (filas != null) this.filas = filas;
    if (columnas != null) this.columnas = columnas;
    if (nombresColumnas != null) this.nombresColumnas = nombresColumnas;
    if (hitsMap != null) this.hitsMap = hitsMap;
    if (datos != null) this.datos = datos;
    if (parametros != null) this.parametros = parametros;
    if (errores != null) this.errores = errores;

    //notifyListeners(); // Notifica a los oyentes sobre los cambios
  }
}
