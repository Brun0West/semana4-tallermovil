import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/prediction_model.dart';

class PredictionController {
  // Cambia esta URL cuando subas a producción (Render)
  final String _baseUrl = 'http://127.0.0.1:5000';   // ← para desarrollo local

  Future<Prediction> makePrediction(double celsius) async {
    final url = Uri.parse('$_baseUrl/predict/$celsius');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        // Convertimos el JSON a nuestro modelo
        return Prediction.fromJson(data);
      } else {
        throw Exception('Error del servidor: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      // Esto es útil para ver errores de conexión o del backend
      rethrow;   // o puedes lanzar un mensaje más amigable
    }
  }
}