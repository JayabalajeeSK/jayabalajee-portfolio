# Step 1: Use official OpenJDK 24 as the base image
FROM openjdk:24-jdk-slim AS build

# Step 2: Set the working directory inside the container
WORKDIR /deployment/jayabalajee-portfolio



# Copy only pom.xml first (for better caching)
COPY pom.xml .

# Download dependencies before copying source files (ensures dependencies are cached)
RUN mvn dependency:go-offline -B

# Copy the rest of the application
COPY src ./src

# Build the project
RUN mvn clean package

FROM openjdk:24-jdk-slim

# Step 7: Set the working directory
WORKDIR /deployment/jayabalajee-portfolio
# Step 9: Expose port 8080
EXPOSE 8080

# Step 8: Copy the built jar from the build stage
COPY --from=build /deployment/jayabalajee-portfolio/target/*.jar app.jar


# Run the application
ENTRYPOINT ["java", "-jar", "/app.jar"]

