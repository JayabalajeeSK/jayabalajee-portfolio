# Step 1: Use official OpenJDK 24 as the base image
FROM openjdk:24-jdk-slim AS build

# Step 2: Set the working directory inside the container
WORKDIR /deployment/jayabalajee-portfolio

# Step 3: Copy pom.xml and download dependencies to use Docker cache efficiently
COPY pom.xml mvnw ./
COPY .mvn .mvn

# Step 4: Download dependencies
RUN ./mvnw dependency:go-offline -B

# Step 5: Copy source code and build the application
COPY src ./src
RUN ./mvnw clean package -DskipTests

# Step 6: Create a new image for running the application
FROM openjdk:24-jdk-slim

# Step 7: Set the working directory
WORKDIR /app

# Step 8: Copy the built jar from the build stage
COPY --from=build /deployment/jayabalajee-portfolio/target/*.jar app.jar

# Step 9: Expose port 8080
EXPOSE 8080

# Step 10: Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
