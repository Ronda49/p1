# -------- Builder Stage --------
FROM node:20-alpine AS builder
WORKDIR /app

# Copy package.json & package-lock.json correctly
COPY app/package*.json ./

RUN npm install

# Copy the full Next.js source
COPY app/ .

# Build Next.js
RUN npm run build

# -------- Runner Stage --------
FROM node:20-alpine AS runner
WORKDIR /app

# Install only production deps
COPY app/package*.json ./
RUN npm install --omit=dev

# Copy built output from builder
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public

EXPOSE 3000

CMD ["npm", "start"]
