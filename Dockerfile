# Etapa 1: Build
FROM node:20-alpine AS builder

WORKDIR /app

# Copia los archivos de dependencias
COPY package*.json ./

# Instala dependencias
RUN npm install --legacy-peer-deps

# Copia el resto del código fuente y el .env generado por el workflow
COPY . .

# Compila la aplicación (NestJS)
RUN npm run build

# Etapa 2: Runtime
FROM node:20-alpine AS runner

WORKDIR /app

# Copia solo lo necesario desde la etapa de build
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/.env ./.env

# Expone el puerto (ajusta si usas otro)
EXPOSE 3000

# Comando por defecto
CMD ["node", "dist/main.js"]