
from flask import Flask, render_template, request, jsonify
import subprocess
import os

app = Flask(__name__)
app.secret_key = 'supersecretkey'

# Directorio de archivos de configuración de Apache
APACHE_CONFIG_DIR = '/etc/apache2/sites-available/'

def get_config_files():
    return [f for f in os.listdir(APACHE_CONFIG_DIR) if f.endswith('.conf')]

def read_apache_config(filename):
    with open(os.path.join(APACHE_CONFIG_DIR, filename), 'r') as file:
        return file.read()

def write_apache_config(filename, config):
    with open(os.path.join(APACHE_CONFIG_DIR, filename), 'w') as file:
        file.write(config)

@app.route('/')
def index():
    config_files = get_config_files()
    return render_template('index.html', config_files=config_files)

@app.route('/config/<filename>')
def config(filename):
    config = read_apache_config(filename)
    return jsonify(config=config)

@app.route('/update/<filename>', methods=['POST'])
def update(filename):
    new_config = request.json['config']
    write_apache_config(filename, new_config)
    reload_apache()
    return jsonify(success=True)

@app.route('/add_member/<filename>', methods=['POST'])
def add_member(filename):
    member_url = request.json['member_url']
    config = read_apache_config(filename)
    new_member = f'BalancerMember {member_url}\n'
    config = config.replace('</Proxy>', f'    {new_member}</Proxy>')
    write_apache_config(filename, config)
    reload_apache()
    return jsonify(success=True)

@app.route('/remove_member/<filename>', methods=['POST'])
def remove_member(filename):
    member_url = request.json['member_url']
    config = read_apache_config(filename)
    config = config.replace(f'BalancerMember {member_url}\n', '')
    write_apache_config(filename, config)
    reload_apache()
    return jsonify(success=True)

def reload_apache():
    result = subprocess.run(['sudo', 'systemctl', 'reload', 'apache2'], capture_output=True, text=True)
    return result.returncode == 0

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)

