package handlers

import (
    "net/http"
    "strconv"
    "github.com/gin-gonic/gin"
    "backend/pkg/services"
)

func GetPlayers(c *gin.Context) {
    players := services.GetAllPlayers()
    c.JSON(http.StatusOK, players)
}

func CreatePlayer(c *gin.Context) {
    var newPlayer models.Player
    if err := c.ShouldBindJSON(&newPlayer); err != nil {
        c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
        return
    }
    player := services.CreatePlayer(newPlayer)
    c.JSON(http.StatusCreated, player)
}

func GetPlayerStats(c *gin.Context) {
    id, _ := strconv.Atoi(c.Param("id"))
    stats := services.GetPlayerStats(id)
    if stats == nil {
        c.JSON(http.StatusNotFound, gin.H{"error": "Player not found"})
        return
    }
    c.JSON(http.StatusOK, stats)
}
