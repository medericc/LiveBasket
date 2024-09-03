package handlers

import (
    "net/http"
    "github.com/gin-gonic/gin"
    "backend/pkg/models"
    "backend/pkg/services"
)

func GetTeams(c *gin.Context) {
    teams := services.GetAllTeams()
    c.JSON(http.StatusOK, teams)
}

func CreateTeam(c *gin.Context) {
    var newTeam models.Team
    if err := c.ShouldBindJSON(&newTeam); err != nil {
        c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
        return
    }
    team := services.CreateTeam(newTeam)
    c.JSON(http.StatusCreated, team)
}

func GetTeamPlayers(c *gin.Context) {
    teamID := c.Param("id")
    players := services.GetPlayersByTeam(teamID)
    if players == nil {
        c.JSON(http.StatusNotFound, gin.H{"error": "Team not found"})
        return
    }
    c.JSON(http.StatusOK, players)
}
