# go-telebot
DevOps and Kubernetes Training Course on Prometheus: Week 2.

A simple Telegram bot written in Go, utilizing the Cobra and Telebot libraries. The bot logs messages and responds to the message "hi". Currently, that's its only functionality.

## Link to the Bot on Telegram
[t.me/devops_course_2024_bot](https://t.me/devops_course_2024_bot)

## Build
To build the project, use the following command with the appropriate version specified:
```
go build -ldflags "-X main.appVersion=v0.0.3"
```

## Usage

Set the environment variable named `TELEGRAM_TOKEN` with your Telegram token and run:
```
./dron-go-telebot start
```

## Recommendations
To find your Telegram bot token, follow these steps:
1. Go to the [@BotFather](https://t.me/botfather) bot on Telegram.
2. Enter the `/token` command.
3. You will see buttons with the bots you've created; select the one you need.

To set the `TELEGRAM_TOKEN` environment variable in a secure manner that doesn't leave sensitive data in the system logs, use the following command:
```
read -s TELEGRAM_TOKEN
export TELEGRAM_TOKEN
```