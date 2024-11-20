FROM node:18-alpine AS frontend-build

WORKDIR /app
COPY package*.json ./
RUN npm install

COPY src/ ./src/
COPY public/ ./public/
COPY webpack.config.js ./
COPY postcss.config.js ./
RUN npm run build

FROM nginx:stable-alpine

COPY --from=frontend-build /app/build /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 3000
CMD ["nginx", "-g", "daemon off;"]
