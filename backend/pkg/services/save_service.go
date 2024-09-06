package services

import (
    "backend/pkg/models"
    "backend/pkg/repositories"
)

// Sauvegarde les statistiques sans terminer le match
func SaveMatchStats(stats []models.MatchStat) {
    for _, stat := range stats {
        repositories.CreateMatchStat(stat)
    }
}

// Termine le match et enregistre les statistiques
func StopMatch(matchID int, stats []models.MatchStat) {
    SaveMatchStats(stats)  // Enregistrer les stats avant d'arrêter
    // Logique pour marquer le match comme terminé dans la base de données
    repositories.MarkMatchAsCompleted(matchID)
}
