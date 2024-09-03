package models

type MatchStat struct {
    PlayerID        int `json:"player_id"`
    MatchID         int `json:"match_id"`
    Points          int `json:"points"`
    Rebounds        int `json:"rebounds"`
    Assists         int `json:"assists"`
    Steals          int `json:"steals"`
    Blocks          int `json:"blocks"`
    Turnovers       int `json:"turnovers"`
    FTMade          int `json:"ft_made"`        // Lancers francs réussis
    FTAttempted     int `json:"ft_attempted"`   // Lancers francs tentés
    ThreePMade      int `json:"3p_made"`        // 3 points réussis
    ThreePAttempted int `json:"3p_attempted"`   // 3 points tentés
    FGMade          int `json:"fg_made"`        // Paniers réussis
    FGAttempted     int `json:"fg_attempted"`   // Paniers tentés
}
