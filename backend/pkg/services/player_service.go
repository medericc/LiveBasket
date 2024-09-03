package services

import (
    "backend/pkg/models"
    "backend/pkg/repositories"
)

func GetAllPlayers() []models.Player {
    return repositories.GetAllPlayers()
}

func CreatePlayer(player models.Player) models.Player {
    return repositories.CreatePlayer(player)
}

func GetPlayerByID(playerID int) *models.Player {
    return repositories.GetPlayerByID(playerID)
}

func GetPlayerStats(playerID int) []models.MatchStat {
    return repositories.GetMatchStatsByPlayer(playerID)
}
