# Base Image
FROM node:18

# Set working directory
WORKDIR /app

# Copy package files and install dependencies
COPY package.json package-lock.json ./ 
RUN npm install

# Copy all source files
COPY . .

# Expose port
EXPOSE 3000

# Start the app
CMD ["node", "server.js"]
