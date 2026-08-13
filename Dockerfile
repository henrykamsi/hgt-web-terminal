FROM node:20

# Install bash and standard utilities
RUN apt-get update && apt-get install -y bash curl git && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

EXPOSE 3000

CMD ["node", "server.js"]
