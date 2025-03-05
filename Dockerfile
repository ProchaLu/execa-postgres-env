FROM node:lts-alpine

WORKDIR /app

# Install dependencies
RUN apk add --no-cache coreutils git postgresql python3 py3-pip build-base bash

# Enable pnpm
RUN corepack enable && corepack prepare pnpm@latest --activate

# Copy files
COPY package.json pnpm-lock.yaml ./
RUN pnpm install --frozen-lockfile
COPY parent.js child.sh ./

# Make scripts executable
RUN chmod +x parent.js child.sh

ENTRYPOINT ["node", "parent.js"]
