# Build Stage
FROM node:18.20.3-slim AS build
WORKDIR /app
# Copy only package files first to leverage caching
COPY package*.json ./
RUN npm install --production
COPY . .
RUN npm run build

# Runtime Stage
FROM node:18.20.3-slim
WORKDIR /app
# Create a non-root user
RUN groupadd -r appgroup && useradd -r -g appgroup appuser
# Copy built files from the build stage
COPY --from=build /app/build ./build
# Switch to non-root user
USER appuser
# Expose port (configurable via ENV)
EXPOSE ${PORT:-3000}
# Health check
HEALTHCHECK --interval=30s --timeout=3s \
  CMD curl -f http://localhost:${PORT:-3000} || exit 1
# Command to run the app
CMD ["npx", "serve", "-s", "build", "-l", "${PORT:-3000}"]
