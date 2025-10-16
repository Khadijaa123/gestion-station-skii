# Étape 1 : image de base avec Java
FROM openjdk:17-jdk-slim

# Étape 2 : définir le répertoire de travail
WORKDIR /app

# Étape 3 : copier le fichier JAR généré par Maven
COPY target/gestion-station-skii-0.0.1-SNAPSHOT.jar app.jar

# Étape 4 : exposer le port (par défaut 8080)
EXPOSE 8080

# Étape 5 : commande pour lancer l'application
ENTRYPOINT ["java", "-jar", "app.jar"]
