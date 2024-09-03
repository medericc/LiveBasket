package repositories

import "backend/pkg/models"

func CreateMatchStat(stat models.MatchStat) models.MatchStat {
    DB.Create(&stat)
    return stat
}

func GetMatchStatsByPlayer(playerID int) []models.MatchStat {
    var stats []models.MatchStat
    DB.Where("player_id = ?", playerID).Find(&stats)
    return stats
}

func GetMatchStatsByTeam(teamID int) []models.MatchStat {
    var teamStats []models.MatchStat
    DB.Where("team_id = ?", teamID).Find(&teamStats)
    return teamStats
}
