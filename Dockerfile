# ----------------------------
# ETAPA 1: Desarrollo
# ----------------------------
FROM instrumentisto/flutter:latest AS development

WORKDIR /app
COPY ./frontend/pubspec.yaml ./frontend/pubspec.lock ./
RUN flutter pub get
COPY ./frontend/ .
RUN flutter build web

# ----------------------------
# ETAPA 2: Producción con NGINX
# ----------------------------
FROM nginx:alpine

# Copiar archivos
COPY --from=development /app/build/web /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

# ✅ Cambiar ruta del PID (evita permisos denegados)
CMD ["nginx", "-g", "pid /tmp/nginx.pid; daemon off;"]

# ✅ Ejecutar como usuario seguro
USER nginx

EXPOSE 80
