# Dockerfile to extend the official Saleor Dashboard
FROM ghcr.io/saleor/saleor-dashboard:latest as base

# Apply custom build arguments
ARG API_URI
ARG APP_MOUNT_URI
ARG STATIC_URL
ARG MARKETPLACE_URL
ARG SALEOR_APPS_ENDPOINT
ARG IS_CLOUD_INSTANCE

ENV API_URI ${API_URI}
ENV APP_MOUNT_URI ${APP_MOUNT_URI}
ENV STATIC_URL ${STATIC_URL}
ENV MARKETPLACE_URL ${MARKETPLACE_URL}
ENV SALEOR_APPS_ENDPOINT ${SALEOR_APPS_ENDPOINT}
ENV IS_CLOUD_INSTANCE ${IS_CLOUD_INSTANCE}

# Copy custom scripts or configurations if needed
#COPY ./custom-configurations /app/configurations

# Start the application
CMD ["npm", "start"]
