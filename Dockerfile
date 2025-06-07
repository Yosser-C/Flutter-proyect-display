# Etapa de construcción
FROM ghcr.io/cirruslabs/flutter:3.29.3 AS build

# Configura usuario no-root (evita problemas de permisos)
RUN useradd -m appuser && mkdir /app && chown -R appuser /app
USER appuser
WORKDIR /app

# Copia solo lo necesario para cachear dependencias
COPY frontend/pubspec.* ./
RUN flutter pub get

# Copia el resto del código
COPY frontend/ .
RUN flutter run -d chrome

# Etapa de producción
FROM nginx:alpine

# Copia los archivos construidos
COPY --from=build /app/build/web /usr/share/nginx/html

# Configuración de Nginx para SPA (Single Page Application)
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]