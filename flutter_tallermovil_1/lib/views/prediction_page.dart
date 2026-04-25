import 'package:flutter/material.dart';
import '../controllers/prediction_controller.dart';

class PredictionPage extends StatefulWidget {
  const PredictionPage({super.key, required this.title});

  final String title;

  @override
  State<PredictionPage> createState() => _PredictionPageState();
}

class _PredictionPageState extends State<PredictionPage> {
  final PredictionController _controller = PredictionController();
  final TextEditingController _celsiusController = TextEditingController();
  String _result = '';
  bool _loading = false;

  bool get _isError => _result.startsWith('Error') || _result.contains('válido') || _result.contains('valor.');

  Future<void> _makePrediction() async {
    final text = _celsiusController.text.trim();

    if (text.isEmpty) {
      setState(() {
        _result = 'Ingrese un valor.';
      });
      return;
    }

    final number = double.tryParse(text);
    if (number == null) {
      setState(() {
        _result = 'Ingrese un número válido.';
      });
      return;
    }

    setState(() {
      _loading = true;
      _result = '';
    });

    try {
      final prediction = await _controller.makePrediction(number);
      setState(() {
        _result = 'Valor previsto en Fahrenheit: ${prediction.fahrenheit.toStringAsFixed(2)}';
      });
    } catch (e) {
      setState(() {
        _result = 'Error: $e';
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffdaf5ff),
      appBar: AppBar(
        title: const Text(
          'Aero Predictor',
          style: TextStyle(
            color: Color(0xff0a3d62),
            fontWeight: FontWeight.w700,
            letterSpacing: 0.4,
          ),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: const Color(0xff0a3d62),
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xffe8f9ff),
              Color(0xffb6ecff),
              Color(0xff8ec9ff),
            ],
          ),
        ),
        child: Stack(
          children: [
            _buildOrb(
              top: -80,
              left: -30,
              size: 220,
              colors: const [Color(0x88ffffff), Color(0x22ffffff)],
            ),
            _buildOrb(
              top: 130,
              right: -60,
              size: 200,
              colors: const [Color(0x77fff7b2), Color(0x11ffffff)],
            ),
            _buildOrb(
              bottom: -70,
              left: 35,
              size: 260,
              colors: const [Color(0x66ffffff), Color(0x11d6fbff)],
            ),
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(22, 110, 22, 30),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: const Color(0x99ffffff), width: 1.3),
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xd9ffffff),
                        Color(0x85d7ecff),
                      ],
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x661568a0),
                        blurRadius: 26,
                        offset: Offset(0, 14),
                      ),
                      BoxShadow(
                        color: Color(0x55ffffff),
                        blurRadius: 10,
                        spreadRadius: -4,
                        offset: Offset(0, -4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Predicción Celsius a Fahrenheit',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          color: Color(0xff144564),
                          fontWeight: FontWeight.w700,
                          shadows: [
                            Shadow(
                              color: Color(0x55ffffff),
                              blurRadius: 10,
                              offset: Offset(0, 1),
                            ),
                          ],
                        )
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Atmosfera retro estilo Frutiger Aero',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xff2f6784),
                          fontSize: 14,
                          letterSpacing: 0.35,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Ingrese valor en Celsius:',
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xff194f70),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _celsiusController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        cursorColor: const Color(0xff0f5f87),
                        style: const TextStyle(
                          color: Color(0xff0a3b58),
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Celsius',
                          labelStyle: const TextStyle(color: Color(0xff2c6c8f)),
                          filled: true,
                          fillColor: const Color(0xccffffff),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: const BorderSide(color: Color(0x88ffffff), width: 1.2),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: const BorderSide(color: Color(0xa3ffffff), width: 1.2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: const BorderSide(color: Color(0xff5cb8f2), width: 1.6),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 52,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            gradient: const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color(0xffbbf3ff),
                                Color(0xff58b8ed),
                                Color(0xff3293cf),
                              ],
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x5527a9e7),
                                blurRadius: 18,
                                offset: Offset(0, 8),
                              ),
                              BoxShadow(
                                color: Color(0x55ffffff),
                                blurRadius: 3,
                                spreadRadius: -1,
                                offset: Offset(0, -2),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: _loading ? null : _makePrediction,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                            ),
                            child: _loading
                                ? const SizedBox(
                                    height: 18,
                                    width: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text(
                                    'Predecir',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.4,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      AnimatedOpacity(
                        opacity: _result.isEmpty ? 0.0 : 1.0,
                        duration: const Duration(milliseconds: 350),
                        child: _buildResultGlass(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultGlass() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: _isError
              ? const [Color(0xb3ffd9d9), Color(0x99ffb9b9)]
              : const [Color(0xb8f5fff3), Color(0x99c6f9da)],
        ),
        border: Border.all(
          color: _isError ? const Color(0x99ff7f7f) : const Color(0x99b2f4cf),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33ffffff),
            blurRadius: 5,
            offset: Offset(0, -1),
          ),
        ],
      ),
      child: Text(
        _result,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: _isError ? const Color(0xff8d1e1e) : const Color(0xff175d3a),
          fontSize: 17,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildOrb({
    double? top,
    double? right,
    double? bottom,
    double? left,
    required double size,
    required List<Color> colors,
  }) {
    return Positioned(
      top: top,
      right: right,
      bottom: bottom,
      left: left,
      child: IgnorePointer(
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: colors,
              radius: 0.8,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _celsiusController.dispose();
    super.dispose();
  }
}