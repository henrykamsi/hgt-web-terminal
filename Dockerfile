FROM node:20-slim

# Install system dependencies & build tools required by node-pty and nano
RUN apt-get update && apt-get install -y \
    python3 \
    make \
    g++ \
    nano \
    curl \
    git \
    bash \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

EXPOSE 3000

CMD ["node", "server.js"]
