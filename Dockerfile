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

# 1. Eliminar configuraciones por defecto que pueden causar conflictos
RUN rm /etc/nginx/conf.d/default.conf

# 2. Copiar archivos estáticos de Flutter
COPY --from=development /app/build/web /usr/share/nginx/html

# 3. Copiar nuestra configuración personalizada (ruta principal)
COPY nginx.conf /etc/nginx/nginx.conf

# 4. Asegurar permisos para /tmp (crucial para Render)
RUN chown -R nginx:nginx /tmp && \
    chmod -R 775 /tmp && \
    chown -R nginx:nginx /var/cache/nginx && \
    chown -R nginx:nginx /var/run

# 5. Comando simplificado (sin definiciones duplicadas)
CMD ["nginx", "-g", "daemon off;"]

# 6. Usar usuario no-root (requerido por Render)
USER nginx

# 7. Exponer el puerto correcto (8080 para Render)
EXPOSE 8080