# ----------------------------
# ETAPA 1: Desarrollo con Chrome
# ----------------------------
FROM instrumentisto/flutter:3.19.5 AS development

# Instalación limpia de Chromium en Alpine
USER root
RUN apk add --no-cache \
    chromium \
    xvfb-run \
    ttf-freefont \
    && flutter config --enable-web

# Configuración del workspace
USER flutter
WORKDIR /app

# Copia selectiva (respetando .dockerignore)
COPY pubspec.yaml pubspec.lock ./
RUN flutter pub get

COPY . .
# ----------------------------
# ETAPA 2: Build de producción
# ----------------------------
FROM development AS build
RUN flutter pub get && \
    flutter build web --release --web-renderer html  # Corregido: usar build en vez de run

# ----------------------------
# ETAPA 3: Servidor de producción
# ----------------------------
FROM nginx:alpine
COPY --from=build /app/build/web /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]