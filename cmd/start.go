/*
Copyright © 2024 NAME HERE <EMAIL ADDRESS>

*/
package cmd

import (
	"fmt"
	"github.com/spf13/cobra"
	telebot "gopkg.in/telebot.v3"
	"log"
	"os"
	"time"
)

var (
	telegramToken = os.Getenv("TELEGRAM_TOKEN")
)

// startCmd represents the start command
var startCmd = &cobra.Command{
	Use:   "start",
	Short: "A brief description of your command",
	Long: `A longer description that spans multiple lines and likely contains examples
and usage of using your command. For example:

Cobra is a CLI library for Go that empowers applications.
This application is a tool to generate the needed files
to quickly create a Cobra application.`,
	Run: func(cmd *cobra.Command, args []string) {
		// fmt.Println("start called")
		fmt.Printf("Telegram bot %s started\n", appVersion)

		bot, err := telebot.NewBot(telebot.Settings{
			URL:    "",
			Token:  telegramToken,
			Poller: &telebot.LongPoller{Timeout: 10 * time.Second},
		})

		if err != nil {
			log.Fatalf("Please check TELEGRAM_TOKEN env variable %s", err)
			return
		}

		bot.Handle(telebot.OnText, func(m telebot.Context) error {
			log.Printf("Payload: %s, Text: %s\n", m.Message().Payload, m.Text())
			payload := m.Message().Text

			switch payload {
				case "hi":
					err = m.Send(fmt.Sprintf("Hi !\n I am devops bot %s.", appVersion))
					
			}

			return err
		})

		bot.Start()
	},
}

func init() {
	rootCmd.AddCommand(startCmd)

	// Here you will define your flags and configuration settings.

	// Cobra supports Persistent Flags which will work for this command
	// and all subcommands, e.g.:
	// startCmd.PersistentFlags().String("foo", "", "A help for foo")

	// Cobra supports local flags which will only run when this command
	// is called directly, e.g.:
	// startCmd.Flags().BoolP("toggle", "t", false, "Help message for toggle")
}
