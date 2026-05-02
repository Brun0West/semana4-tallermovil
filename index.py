# Importar librerías necesarias
from flask import Flask, request, jsonify
from flask_cors import CORS
import tensorflow as tf
import numpy as np
from tensorflow.keras.preprocessing import image
import os
from werkzeug.utils import secure_filename
import matplotlib

# Usar backend 'Agg' para evitar problemas de visualización en servidor
matplotlib.use('Agg')

import matplotlib.pyplot as plt

# Crear aplicación Flask y habilitar CORS
app = Flask(__name__)
CORS(app)

# Cargar modelo TensorFlow Lite entrenado
interpreter = tf.lite.Interpreter(model_path='brain_tumor_cnn.tflite')
interpreter.allocate_tensors()

# Obtener detalles de entrada y salida del modelo
input_details = interpreter.get_input_details()
output_details = interpreter.get_output_details()

# Clases de clasificación posibles
class_names = ['glioma', 'meningioma', 'notumor', 'pituitary']

# Configurar carpeta para guardar imágenes subidas
UPLOAD_FOLDER = os.path.join('static', 'uploads')
os.makedirs(UPLOAD_FOLDER, exist_ok=True)
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

# Función para hacer predicciones con el modelo TFLite
def predict_with_tflite(img_array):
    """
    Normaliza la imagen y realiza predicción
    Retorna probabilidades para cada clase
    """
    img_array = img_array.astype(np.float32)/255.0  # Normalizar a [0,1]
    interpreter.set_tensor(input_details[0]['index'], img_array)
    interpreter.invoke()  # Ejecutar el modelo
    output_data = interpreter.get_tensor(output_details[0]['index'])
    return output_data[0]

# Endpoint API para clasificar imágenes
@app.route('/api/clasificar', methods=['POST'])
def clasificar_api():
    """
    Recibe imagen, realiza predicción y retorna resultados con gráfico
    """
    # Validar que se envió imagen
    file = request.files.get('image')
    if not file:
        return jsonify({'error': 'No se envió imagen'}), 400
    
    # Guardar imagen de forma segura
    filename = secure_filename(file.filename)
    filepath = os.path.join(app.config['UPLOAD_FOLDER'], filename)
    file.save(filepath)
    
    # Cargar y preprocesar imagen (redimensionar a 128x128)
    img = image.load_img(filepath, target_size=(128, 128))
    img_array = image.img_to_array(img)
    img_array = np.expand_dims(img_array, axis=0)  # Añadir dimensión de batch
    
    # Realizar predicción
    prediction = predict_with_tflite(img_array)
    predicted_class = class_names[np.argmax(prediction)]
    
    # Obtener probabilidades para cada clase
    probabilities = {
        class_names[i]: float(f"{prob:.4f}")
        for i, prob in enumerate(prediction)
    }
    
    # Generar gráfico de barras con las probabilidades
    plt.figure(figsize=(6, 4))
    plt.bar(probabilities.keys(), probabilities.values(), color='skyblue')
    plt.title('Probabilidades por clase')
    plt.ylabel('Confianza')
    plt.tight_layout()
    
    # Guardar gráfico
    graph_path = os.path.join(app.config['UPLOAD_FOLDER'], 'probabilidades.png')
    plt.savefig(graph_path)
    plt.close()
    
    # Retornar resultados en JSON
    return jsonify({
        'prediction': f'Predicción: {predicted_class.upper()}',
        'image_name': filename,
        'probs': probabilities
    })

# Ejecutar aplicación
if __name__ == '__main__':
    app.run(debug=True, port=5000)
