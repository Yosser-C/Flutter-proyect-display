# ----------------------------
# ETAPA 1: Desarrollo
# ----------------------------
FROM instrumentisto/flutter:latest AS development

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
RUN flutter build web

# ----------------------------
# ETAPA 3: Servidor de producción
# ----------------------------
FROM nginx:alpine
COPY --from=development /app/build/web /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]