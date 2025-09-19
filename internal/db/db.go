package db

import (
	"context"
	"log"

	"test-go2/ent"
)

func RunMigrations(client *ent.Client) error {
	if err := client.Schema.Create(context.Background()); err != nil {
		return err
	}
	log.Println("✅ Migraciones aplicadas con éxito")
	return nil
}
