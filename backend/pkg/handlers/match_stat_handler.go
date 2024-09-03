package handlers

import (
    "net/http"
    "strconv"
    "github.com/gin-gonic/gin"
    "backend/pkg/models"
    "backend/pkg/services"
)

func CreateMatchStat(c *gin.Context) {
    var newStat models.MatchStat
    if err := c.ShouldBindJSON(&newStat); err != nil {
        c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
        return
    }
    stat := services.CreateMatchStat(newStat)
    c.JSON(http.StatusCreated, stat)
}

func GetMatchStatsForPlayer(c *gin.Context) {
    playerID, _ := strconv.Atoi(c.Param("player_id"))
    stats := services.GetMatchStatsByPlayer(playerID)
    if stats == nil {
        c.JSON(http.StatusNotFound, gin.H{"error": "No stats found for this player"})
        return
    }
    c.JSON(http.StatusOK, stats)
}
