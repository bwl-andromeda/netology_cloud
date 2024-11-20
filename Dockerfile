# Frontend Dockerfile
FROM node:18-alpine as frontend-build

WORKDIR /app
COPY package*.json ./
COPY .env ./
RUN npm install

COPY src/ ./src/
COPY public/ ./public/
COPY webpack.config.js ./
COPY postcss.config.js ./
RUN npm run build

FROM node:18-alpine as frontend-serve
WORKDIR /app
COPY --from=frontend-build /app/build ./build
RUN npm install -g serve
EXPOSE 3000
CMD ["serve", "-s", "build", "-p", "3000"]


# Backend Dockerfile
FROM python:3.10-slim as backend

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY .env ./
COPY manage.py ./
COPY accounts/ ./accounts/
COPY server/ ./server/
COPY storage/ ./storage/
COPY logs/ ./logs/
COPY static/ ./static

RUN chmod +x manage.py

EXPOSE 8000
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]

