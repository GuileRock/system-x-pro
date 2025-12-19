import os
from flask import Flask
from redis import Redis

app = Flask(__name__)

# --- Configuração Dinâmica ---
# O código tenta pegar o endereço do Redis da variável de ambiente 'REDIS_HOST'.
# Se não encontrar (ex: rodando local sem docker), usa 'localhost'.
redis_host = os.environ.get('REDIS_HOST', 'localhost')

# Conexão com o Banco
redis = Redis(host=redis_host, port=6379)

@app.route('/')
def hello():
    # Incrementa o contador 'hits' no Redis
    try:
        redis.incr('hits')
        count = redis.get('hits').decode('utf-8')
        return f"<h1>Projeto System-X</h1><p>Esta página foi vista <strong>{count}</strong> vezes.</p>"
    except Exception as e:
        return f"<h1>Erro de Conexão</h1><p>Não foi possível conectar ao Redis em {redis_host}.</p><p>Erro: {e}</p>"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
