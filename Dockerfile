# Etapa 1: Build (instalação das dependências)
FROM python:3.8-slim as build

# Defina o diretório de trabalho para /app
WORKDIR /app

# Copie o arquivo de requisitos para a imagem
COPY requirements.txt .

# Instale as dependências necessárias
RUN pip install --no-cache-dir -r requirements.txt

# Instale o Jupyter Notebook
RUN pip install --no-cache-dir jupyter

# Etapa 2: Final (imagem final)
FROM python:3.8-slim

# Defina o diretório de trabalho para /app
WORKDIR /app

# Copie as dependências e os binários necessários da etapa de build
COPY --from=build /usr/local/lib/python3.8/site-packages /usr/local/lib/python3.8/site-packages
COPY --from=build /usr/local/bin/ /usr/local/bin/

# Exponha a porta 8888
EXPOSE 8888

# Defina a variável de ambiente
ENV NAME World

# Copie o conteúdo do diretório atual para o diretório /app dentro do container
COPY . .

# Comando para iniciar o Jupyter Notebook
CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root"]
