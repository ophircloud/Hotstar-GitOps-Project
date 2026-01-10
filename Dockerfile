# Use Node.js Alpine base image
#FROM node:alpine

# Create and set the working directory inside the container
#WORKDIR /app

# Copy package.json and package-lock.json to the working directory
#COPY package.json package-lock.json /app/

# Install dependencies
#RUN npm install

# Copy the entire codebase to the working directory
#COPY . /app/

# Expose the port your app runs on (replace <PORT_NUMBER> with your app's actual port)
#EXPOSE 3000

# Define the command to start your application (replace "start" with the actual command to start your app)
#CMD ["npm", "start"]


# Use Node.js Alpine base image
FROM node:alpine

# Create a non-root user and group
RUN addgroup -S nodejs && adduser -S nodejs -G nodejs

# Create and set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json to the working directory
COPY package.json package-lock.json /app/

# Install dependencies
RUN npm install

# Copy the entire codebase to the working directory
COPY . /app/

# Give ownership of the working directory to the non-root user
RUN chown -R nodejs:nodejs /app

# Switch to the non-root user
USER nodejs

# Expose the port your app runs on
EXPOSE 3000

# Define the command to start your application
CMD ["npm", "start"]
