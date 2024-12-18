FROM node:20-slim AS builder
RUN corepack enable
WORKDIR /app
COPY . .

RUN pnpm install --frozen-lockfile
RUN pnpm build

FROM nginx:alpine AS base
COPY --from=builder /app/nginx.conf /etc/nginx/conf.d/default.conf
WORKDIR /usr/share/nginx/html
COPY --from=builder /app/dist .
ENTRYPOINT ["nginx", "-g", "daemon off;"]
