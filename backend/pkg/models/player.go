package models

type Player struct {
    ID       int    `json:"id"`
    Name     string `json:"name"`
    Number   int    `json:"number"`
    TeamID   int    `json:"team_id"`
}
