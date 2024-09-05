# Étape 1 : Utiliser une image Go pour compiler l'application
FROM golang:1.19 AS builder

# Définir le répertoire de travail à l'intérieur du conteneur
WORKDIR /app

# Copier les fichiers go.mod et go.sum et télécharger les dépendances
COPY go.mod go.sum ./
RUN go mod download

# Copier tout le projet dans le conteneur
COPY . .

# Compiler l'application
RUN go build -o app .

# Étape 2 : Créer l'image finale plus légère
FROM alpine:latest

# Définir le répertoire de travail dans le nouveau conteneur
WORKDIR /root/

# Copier l'application compilée depuis l'étape précédente
COPY --from=builder /app/app .

# Exposer le port sur lequel l'application Go va tourner
EXPOSE 8080

# Commande pour exécuter l'application
CMD ["./app"]
