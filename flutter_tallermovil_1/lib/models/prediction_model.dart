class Prediction {
  final double celsius;
  final double fahrenheit;

  Prediction({required this.celsius, required this.fahrenheit});

  factory Prediction.fromJson(Map<String, dynamic> json) {
    return Prediction(
      celsius: (json['celsius'] as num).toDouble(), 
      fahrenheit: (json['fahrenheit'] as num).toDouble());
  }
}
