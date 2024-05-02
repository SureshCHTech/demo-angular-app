# Stage 1: Build Angular application
FROM node:latest as build
WORKDIR /app

# Copy only package.json and package-lock.json to leverage Docker cache
COPY package*.json ./
RUN npm install

# Copy the rest of the application
COPY . .

# Build the Angular application for production
RUN npm run build --prod

# Stage 2: Serve Angular application using Nginx
FROM nginx:alpine

# Copy built Angular app from previous stage to Nginx directory
COPY --from=build /app/dist/angular-app /usr/share/nginx/html

# Remove default nginx configurations
RUN rm /etc/nginx/conf.d/default.conf

# Copy custom nginx configuration if needed
# COPY nginx.conf /etc/nginx/conf.d

# Expose port 80 for Nginx
EXPOSE 80

# Start Nginx when container starts
CMD ["nginx", "-g", "daemon off;"]
