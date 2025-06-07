# Usa la imagen oficial de Flutter para web
FROM instrumentisto/flutter:3.19.5 AS build

# Configura el entorno (evita problemas de permisos)
RUN mkdir /app && chown -R flutter:flutter /app
WORKDIR /app
USER flutter

# Copia solo los archivos necesarios inicialmente para cachear dependencias
COPY pubspec.* ./
RUN flutter pub get

# Copia el resto del código
COPY . .
RUN flutter build web --release --web-renderer html

# Fase de producción con Nginx
FROM nginx:alpine
COPY --from=build /app/build/web /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]