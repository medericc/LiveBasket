package models

type Team struct {
    ID      int      `json:"id"`
    Name    string   `json:"name"`
    Players []Player `json:"players"`
}
