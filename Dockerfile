# Usa la imagen con Chrome incluido
FROM instrumentisto/flutter:3.19.5 AS development

# Instala dependencias para Chrome (solo en etapa de desarrollo)
USER root
RUN apt-get update && \
    apt-get install -y \
    wget \
    xvfb \
    && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list \
    && apt-get update \
    && apt-get install -y google-chrome-stable \
    && rm -rf /var/lib/apt/lists/*

# Configura el entorno de desarrollo
USER flutter
WORKDIR /app
COPY . .

# Comando para desarrollo (ejecutar con docker-compose)
CMD ["flutter", "run", "-d", "chrome", "--web-port", "8080", "--web-hostname", "0.0.0.0"]

# Etapa de construcción para producción
FROM development AS build
RUN flutter pub get && \
    flutter build web --release --web-renderer html

# Etapa final de producción
FROM nginx:alpine
COPY --from=build /app/build/web /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]