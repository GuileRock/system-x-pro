# Usa uma imagem base oficial do Python (leve, versão slim)
FROM python:3.9-slim

# Define a pasta de trabalho dentro do container
WORKDIR /app

# Copia os arquivos da sua VM para dentro do container
COPY . .

# Instala as dependências listadas
RUN pip install --no-cache-dir -r requirements.txt

# Expõe a porta 5000 (padrão do Flask)
EXPOSE 5000

# Comando para rodar a aplicação
CMD ["python", "app.py"]
