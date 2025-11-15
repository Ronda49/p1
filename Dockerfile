# -------- Builder Stage --------
FROM node:20-alpine AS builder
WORKDIR /app

COPY app/package*.json ./
RUN npm install

COPY app/ .
RUN npm run build

# -------- Runner Stage --------
FROM node:20-alpine AS runner
WORKDIR /app

COPY app/package*.json ./
RUN npm install --omit=dev

COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public

EXPOSE 3000
CMD ["npm", "start"]
