# ----------------------------
# ETAPA 1: Desarrollo
# ----------------------------
FROM instrumentisto/flutter:3.19.5 AS development

# Instala Chromium sin cambiar de usuario
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        chromium \
        xvfb \
    && rm -rf /var/lib/apt/lists/*

# Configura el workspace (usando usuario existente)
WORKDIR /app

# Copia SOLO lo esencial primero
COPY ./frontend/pubspec.yaml ./frontend/pubspec.lock ./
RUN flutter pub get

# Copia el resto
COPY ./frontend/ .

# ----------------------------
# ETAPA 2: Build de producción
# ----------------------------
RUN flutter build web --release --web-renderer html

# ----------------------------
# ETAPA 3: Servidor de producción
# ----------------------------
FROM nginx:alpine
COPY --from=development /app/build/web /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]