FROM instrumentisto/flutter:3.19.5 AS development

# Instalación de dependencias
USER root
RUN apk add --no-cache chromium xvfb-run
USER flutter

# Configuración del workspace
WORKDIR /app

# Copia SOLO lo esencial primero
COPY frontend/pubspec.yaml frontend/pubspec.lock ./
RUN flutter pub get

# Copia el resto del código Flutter
COPY frontend/ .

# Build de producción
RUN flutter build web --release --web-renderer html

# Servidor de producción
FROM nginx:alpine
COPY --from=development /app/build/web /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]