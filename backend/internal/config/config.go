package config

import (
    "os"
    "log"
)

type Config struct {
    DatabaseURL string
    Port        string
}

var AppConfig Config

func LoadConfig() {
    AppConfig = Config{
        DatabaseURL: getEnv("DATABASE_URL", "root:@tcp(localhost:3306)/basketball?charset=utf8mb4&parseTime=True&loc=Local"),
        Port:        getEnv("PORT", "8080"),
    }
}

func getEnv(key, fallback string) string {
    if value, exists := os.LookupEnv(key); exists {
        return value
    }
    return fallback
}

func init() {
    LoadConfig()
    log.Printf("Config loaded: %+v\n", AppConfig)
}
