package repositories

import "backend/pkg/models"

func GetAllTeams() []models.Team {
    var teams []models.Team
    DB.Find(&teams)
    return teams
}

func CreateTeam(team models.Team) models.Team {
    DB.Create(&team)
    return team
}

func GetPlayersByTeamID(teamID int) []models.Player {
    var team models.Team
    DB.Preload("Players").First(&team, teamID)
    return team.Players
}
