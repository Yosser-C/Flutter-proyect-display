# ----------------------------
# ETAPA 1: Desarrollo
# ----------------------------
FROM instrumentisto/flutter:latest AS development

WORKDIR /app

# Copia solo lo necesario primero (cache eficiente)
COPY ./frontend/pubspec.yaml ./frontend/pubspec.lock ./
RUN flutter pub get

# Luego copia el resto del proyecto
COPY ./frontend/ .

# ----------------------------
# ETAPA 2: Build de producción
# ----------------------------
RUN flutter build web

# ----------------------------
# ETAPA 3: Servidor de producción
# ----------------------------
FROM nginx:alpine

# Copia el build generado
COPY --from=development /app/build/web /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expone el puerto por defecto de NGINX
EXPOSE 80

# ✅ Seguridad: ejecutar como usuario no root
USER nginx

CMD ["nginx", "-g", "daemon off;"]
