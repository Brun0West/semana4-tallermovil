from flask import Flask, jsonify, render_template, request
from flask_cors import CORS
import numpy as np
import tensorflow as tf
# =========================
# CONFIG
# =========================
MODEL_PATH = "model_c2f.tflite"
app = Flask(__name__)
CORS(app) # <-- HABILITA CORS
interpreter = tf.lite.Interpreter(model_path=MODEL_PATH)
interpreter.allocate_tensors()
input_details = interpreter.get_input_details()
output_details = interpreter.get_output_details()


@app.route("/")
def inicio():
    return render_template("login.html", mensaje="")

@app.route("/login", methods=["POST"])
def login():
    usuario = request.form.get("usuario")
    clave = request.form.get("clave")
    
    if usuario == "admin" and clave == "1234":
        return f"<h1>Bienvenido, {usuario}</h1><p>Acceso correcto.</p>"
    else:
        return render_template("login.html", mensaje="Usuario o contraseña incorrectos")

@app.route("/predict/<float:celsius>", methods=["GET"])
def predict_get(celsius):
    # PREPARE INPUT (shape: 1x1)
    input_data = np.array([[celsius]], dtype=np.float32)
    interpreter.set_tensor(input_details[0]["index"], input_data)
    interpreter.invoke()
    output = interpreter.get_tensor(output_details[0]["index"])
    fahrenheit = float(output[0][0])
    return jsonify({
        "celsius": celsius,
        "fahrenheit": fahrenheit
    })

if __name__ == "__main__":
    app.run(debug=True)