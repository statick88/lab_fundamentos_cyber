from flask import Flask, request, jsonify

app = Flask(__name__)

@app.route('/', methods=['GET'])
def index():
    producto = request.args.get('producto', 'laptop')
    rol = request.args.get('rol', 'usuario')
    precio = request.args.get('precio', '999')
    return jsonify({
        'mensaje': f'Producto: {producto}',
        'rol': rol,
        'precio_original': precio
    })

@app.route('/compra', methods=['POST'])
def compra():
    producto = request.form.get('producto', 'desconocido')
    precio = request.form.get('precio', '999')
    rol = request.form.get('rol', 'usuario')
    origen = request.form.get('origen', 'unknown')
    
    # Lógica de intercepción: si precio es 999 y rol es usuario, es objetivo de modificación
    modificado = False
    if precio == '999' and rol == 'usuario':
        # En escenario real, Burp interceptaría y modificaría aquí
        modificado = True
    
    return jsonify({
        'mensaje': f'Compra registrada: {producto}',
        'precio': precio,
        'rol': rol,
        'origen': origen,
        'modificado': modificado
    })

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=False)
