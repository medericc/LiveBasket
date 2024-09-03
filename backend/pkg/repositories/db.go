package repositories

import (
    "gorm.io/driver/mysql"
    "gorm.io/gorm"
    "log"
    "backend/internal/config"
)

var DB *gorm.DB

func InitDB() {
    var err error
    DB, err = gorm.Open(mysql.Open(config.AppConfig.DatabaseURL), &gorm.Config{})
    if err != nil {
        log.Fatal("Failed to connect to database: ", err)
    }
    log.Println("Database connected")
}

func AutoMigrate() {
    DB.AutoMigrate(&Player{}, &Team{}, &MatchStat{})
}
