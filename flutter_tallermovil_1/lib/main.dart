import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const PredictionPage(title: 'Flutter Demo Home Page'),
    );
  }
}
class PredictionPage extends StatefulWidget {
  const PredictionPage({super.key, required this.title});
  final String title;
  @override
  State<PredictionPage> createState() => _PredictionPageState();
}

class _PredictionPageState extends State<PredictionPage> {

  final TextEditingController celsiusController = TextEditingController();
  String result = '';
  bool loading = false;
  // Para emulador Android:
  final String baseUrl = 'http://127.0.0.1:5000';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff7eef7),
      appBar: AppBar(
        title: const Text('Predicción Celsius → Fahrenheit'),
        centerTitle: true,
        backgroundColor: const Color(0xfff7eef7),
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Ingrese valor en Celsius:',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: celsiusController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                    signed: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Celsius',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: loading ? null : consumirApi,
                  child: loading
                      ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                      : const Text('Predict'),
                ),
                const SizedBox(height: 25),
                Text(
                  result,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Future<void> consumirApi() async {
    final texto = celsiusController.text.trim();
    if (texto.isEmpty) {
      setState(() {
        result = 'Ingrese un valor.';
      });
      return;
    }
    final numero = double.tryParse(texto);
    if (numero == null) {
      setState(() {
        result = 'Ingrese un número válido.';
      });
      return;
    }
    setState(() {
      loading = true;
      result = '';
    });
    try {
      final url = Uri.parse('$baseUrl/predict/$numero');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final double celsius = (data['celsius'] as num).toDouble();
        final double fahrenheit = (data['fahrenheit'] as num).toDouble();
        setState(() {
          result =
          'Valor previsto en Fahrenheit:\n${fahrenheit.toStringAsFixed(6)}';
        });
        debugPrint('Celsius: $celsius');
        debugPrint('Fahrenheit: $fahrenheit');
      } else {
        setState(() {
          result = 'Error del servidor: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        result = 'No se pudo conectar con la API.\n$e';
      });
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void dispose() {
    celsiusController.dispose();
    super.dispose();
  }

}
