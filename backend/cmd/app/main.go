package main

import (
    "backend/pkg/handlers"
    "backend/pkg/repositories"
    "github.com/gin-gonic/gin"
    "log"
)

func main() {
    // Initialiser la base de données
    repositories.InitDB()
    repositories.AutoMigrate()

    // Créer un routeur Gin
    r := gin.Default()

    // Configurer les routes
    r.GET("/players", handlers.GetPlayers)
    r.POST("/players", handlers.CreatePlayer)
    // Ajouter d'autres routes pour les équipes et les stats de match

    // Lancer l'application
    if err := r.Run(":8080"); err != nil {
        log.Fatal("Failed to run server: ", err)
    }
}
