package services

import "backend/pkg/models"

// Simule une base de données en mémoire
var matchStats []models.MatchStat

func CreateMatchStat(stat models.MatchStat) models.MatchStat {
    matchStats = append(matchStats, stat)
    return stat
}

func GetMatchStatsByPlayer(playerID int) []models.MatchStat {
    var stats []models.MatchStat
    for _, stat := range matchStats {
        if stat.PlayerID == playerID {
            stats = append(stats, stat)
        }
    }
    return stats
}
