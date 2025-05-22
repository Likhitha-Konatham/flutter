## Use the official Flutter image as the base image for building the app
FROM ghcr.io/cirruslabs/flutter:3.32.0 AS build

# Set the working directory
WORKDIR /app

# Copy the pubspec files and install dependencies
COPY pubspec.* ./
RUN flutter pub get

# Copy the rest of your application code
COPY . .

# Build the Flutter web app with a specific base href to fix the blank page issue
RUN flutter build web --release --base-href="/workflowfeprod/"

# Use the official Nginx image
FROM nginx:alpine

# Copy the build output to the Nginx html directory
COPY --from=build /app/build/web /usr/share/nginx/html

# Expose port 5054
EXPOSE 5054

# Set the default page to index.html
RUN echo "server { \
    listen 5054; \
    location / { \
        root /usr/share/nginx/html; \
        index index.html; \
    } \
}" > /etc/nginx/conf.d/default.conf

# Start Nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]
