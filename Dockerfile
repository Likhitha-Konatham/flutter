### Stage 1: Build the Flutter web app
FROM ghcr.io/cirruslabs/flutter:latest AS build

# Set working directory
WORKDIR /app

# Copy pubspec files and install dependencies
COPY pubspec.* ./
RUN flutter pub get

# Copy the rest of the source code
COPY . .

# Build the web app
RUN flutter build web

### Stage 2: Serve using Nginx
FROM nginx:alpine

# Remove default nginx page
RUN rm -rf /usr/share/nginx/html/*

# Copy built web app from build stage to nginx html folder
COPY web /usr/share/nginx/html

# Expose port 80 for HTTP
EXPOSE 80

# Run Nginx
CMD ["nginx", "-g", "daemon off;"]

