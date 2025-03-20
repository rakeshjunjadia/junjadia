from flask import Flask, request
import subprocess

app = Flask(__name__)

@app.route('/webhook', methods=['POST'])
def webhook():
    data = request.json
    if data.get("ref") == "refs/heads/main":  # Sirf main branch par trigger hoga
        subprocess.run(["ansible-playbook", "-i", "/root/ansible/inventory", "/root/ansible/deploy.yml"])
        return {"status": "success"}, 200

    return {"status": "ignored"}, 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)

