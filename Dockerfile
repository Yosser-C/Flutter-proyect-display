# ----------------------------
# ETAPA 1: Desarrollo
# ----------------------------
FROM instrumentisto/flutter:3.19.5 AS development

# Instala Chrome (USANDO apt - DEBIAN)
USER root
RUN apt-get update && \
    apt-get install -y \
    wget \
    xvfb \
    && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list \
    && apt-get update \
    && apt-get install -y google-chrome-stable \
    && rm -rf /var/lib/apt/lists/*

# Configura el workspace
USER flutter
WORKDIR /app

# Copia SOLO lo esencial primero (asegúrate que pubspec.yaml existe en ./frontend)
COPY ./frontend/pubspec.yaml ./frontend/pubspec.lock ./
RUN flutter pub get

# Copia el resto
COPY ./frontend/ .

# ----------------------------
# ETAPA 2: Build de producción
# ----------------------------
FROM development AS builder
RUN flutter build web --release --web-renderer html

# ----------------------------
# ETAPA 3: Servidor de producción
# ----------------------------
FROM nginx:alpine
COPY --from=builder /app/build/web /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]