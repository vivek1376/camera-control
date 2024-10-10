from flask import Flask, request, jsonify, send_from_directory

app = Flask(__name__)
status = {'enabled': True}

@app.route('/status', methods=['GET'])
def get_status():
    return jsonify(status)

@app.route('/toggle', methods=['POST'])
def toggle():
    global status
    status['enabled'] = not status['enabled']
    return jsonify(status)

@app.route('/', methods=['GET'])
def index():
    return send_from_directory('.', 'index.html')

if __name__ == '__main__':
    app.run(host='127.0.0.1', port=5001)

