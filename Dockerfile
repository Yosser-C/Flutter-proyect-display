FROM ghcr.io/cirruslabs/flutter:3.13.9 AS build

WORKDIR /app
COPY frontend .
RUN flutter pub get && flutter build web --release --web-renderer html

FROM nginx:alpine
COPY --from=build /app/build/web /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]