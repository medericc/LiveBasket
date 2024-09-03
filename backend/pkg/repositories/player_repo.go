package repositories

import "backend/pkg/models"

func GetAllPlayers() []models.Player {
    var players []models.Player
    DB.Find(&players)
    return players
}

func CreatePlayer(player models.Player) models.Player {
    DB.Create(&player)
    return player
}

func GetPlayerByID(playerID int) *models.Player {
    var player models.Player
    DB.First(&player, playerID)
    if player.ID == 0 {
        return nil
    }
    return &player
}
