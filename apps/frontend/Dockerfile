# Stage 1 — copy assets
FROM nginx:alpine AS builder
COPY src/ /usr/share/nginx/html/

# Stage 2 — runtime
FROM nginx:alpine
COPY --from=builder /usr/share/nginx/html/ /usr/share/nginx/html/
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]