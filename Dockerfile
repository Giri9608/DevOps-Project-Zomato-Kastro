# Use Node.js 18 slim as the base image (recommended by SonarQube and stable for your project)
FROM node:18-slim

# Set working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json for dependency installation
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Expose the port the app runs on (default for Create React App is 3000)
EXPOSE 3000

# Build the React app for production
RUN npm run build

# Serve the built app using a simple server (using 'serve' package)
# Note: 'serve' is installed globally here for simplicity; alternatively, use a custom server
RUN npm install -g serve

# Command to run the app
CMD ["serve", "-s", "build", "-l", "3000"]
