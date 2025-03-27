# Step 1: Use openjdk 24 as the base image
FROM openjdk:24-jdk-slim AS build

# Install Maven manually
RUN apt-get update && apt-get install -y wget \
    && wget https://downloads.apache.org/maven/maven-3/3.9.5/binaries/apache-maven-3.9.5-bin.tar.gz \
    && tar -xvzf apache-maven-3.9.5-bin.tar.gz -C /usr/share \
    && ln -s /usr/share/apache-maven-3.9.5/bin/mvn /usr/bin/mvn

# Set the working directory
WORKDIR /deployment/jayabalajee-portfolio

# Copy pom.xml and .mvn to download dependencies first
COPY pom.xml mvnw ./
COPY .mvn .mvn

# Download dependencies
RUN mvn dependency:go-offline -B

# Copy the application source code
COPY src ./src

# Build the application
RUN mvn clean package -DskipTests

# Step 2: Use a minimal OpenJDK 24 image to run the application
FROM openjdk:24-jdk-slim

# Set the working directory in the container
WORKDIR /app

# Copy the built JAR file from the build stage
COPY --from=build /deployment/jayabalajee-portfolio/target/jayabalajee-portfolio-0.0.1-SNAPSHOT.jar app.jar

# Expose the application port
EXPOSE 8080

# Run the application
CMD ["java", "-jar", "app.jar"]
