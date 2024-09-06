package handlers

import (
    "net/http"
    "github.com/gin-gonic/gin"
     "backend/pg/models"
    "backend/pkg/services"
)

// Sauvegarde intermédiaire
func SaveMatchStats(c *gin.Context) {
    var stats []models.MatchStat
    if err := c.ShouldBindJSON(&stats); err != nil {
        c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
        return
    }
    services.SaveMatchStats(stats)
    c.JSON(http.StatusOK, gin.H{"message": "Stats sauvegardées !"})
}

// Arrêter et enregistrer le match
func StopMatch(c *gin.Context) {
    var stats []models.MatchStat
    matchID := c.Param("match_id")

    if err := c.ShouldBindJSON(&stats); err != nil {
        c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
        return
    }

    services.StopMatch(matchID, stats)
    c.JSON(http.StatusOK, gin.H{"message": "Match terminé et stats sauvegardées !"})
}
