FROM ghcr.io/cirruslabs/flutter:3.19.5 AS build

# Configura el entorno
WORKDIR /app
COPY . .

# Instala dependencias y construye (CORREGIDO)
RUN flutter pub get && \
    flutter build web --release --web-renderer html

FROM nginx:alpine
COPY --from=build /app/build/web /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]