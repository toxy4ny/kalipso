#!/bin/bash

# Bash script for installing Docker, downloading Kali Linux (ARM) and automatically launching the container
# Works for Orange Pi3B (Armbian)

YELLOW="\033[1;33m"
CYAN="\033[0;36m"
GRAY="\033[1;30m"
GREEN="\033[0;32m"
RESET="\033[0m"

# Первая часть (замок)
echo -e "${CYAN}                                  |>>>${RESET}"
echo -e "${CYAN}                                  |${RESET}"
echo -e "${CYAN}                    |>>>      _  _|_  _         |>>>${RESET}"
echo -e "${CYAN}                    |        |;| |;| |;|        |${RESET}"
echo -e "${YELLOW}                _  _|_  _    \\.    .  /    _  _|_  _${RESET}"
echo -e "${YELLOW}               |;|_|;|_|;|    \\:. ,  /    |;|_|;|_|;|${RESET}"
echo -e "${YELLOW}               \\..      /    ||;   . |    \\.    .  /${RESET}"
echo -e "${YELLOW}                \\.  ,  /     ||:  .  |     \\:  .  /${RESET}"
echo -e "${YELLOW}                 ||:   |_   _ ||_ . _ | _   _||:   |${RESET}"
echo -e "${YELLOW}                 ||:  .|||_|;|_|;|_|;|_|;|_|;||:.  |${RESET}"
echo -e "${YELLOW}                 ||:   ||.    .     .      . ||:  .|${RESET}"
echo -e "${YELLOW}                 ||: . || .     . .   .  ,   ||:   |       \,/${RESET}"
echo -e "${YELLOW}                 ||:   ||:  ,  _______   .   ||: , |            /\`${RESET}"
echo -e "${YELLOW}                 ||:   || .   /+++++++\    . ||:   |${RESET}"
echo -e "${YELLOW}                 ||:   ||.    |+++++++| .    ||: . |${RESET}"
echo -e "${YELLOW}              __ ||: . ||: ,  |+++++++|.  . _||_   |${RESET}"
echo -e "${GRAY}     ____--\`~    '--~~__|.    |+++++__|----~    ~\`---,              ___${RESET}"
echo -e "${GRAY}-~--~                   ~---__|,--~'                  ~~----_____-~'   \`~----~~${RESET}"

# Вторая часть (блок)
echo -e "${GREEN}▖▖  ▜ ▘      ${RESET}"
echo -e "${GREEN}▙▘▀▌▐ ▌▛▌▛▘▛▌${RESET}"
echo -e "${GREEN}▌▌█▌▐▖▌▙▌▄▌▙▌${RESET}"
echo -e "${GREEN}       ▌      by KL3FT3Z (https://github.com/toxy4ny)${RESET}"
echo -e "${GREEN}Bash script for installing Docker, downloading Kali Linux (ARM) and automatically launching the Container${RESET}" 

set -e

CONTAINER_NAME="kali-container"
KALI_HOME="$HOME/kali_data"

echo "==> Checking if a container with Kali Linux exists..."

if sudo docker ps -a --format '{{.Names}}' | grep -wq "$CONTAINER_NAME"; then
    echo "==> The $CONTAINER_NAME container already exists. Launching an interactive session..."
   
    if ! sudo docker ps --format '{{.Names}}' | grep -wq "$CONTAINER_NAME"; then
        sudo docker start "$CONTAINER_NAME"
    fi
    sudo docker exec -it "$CONTAINER_NAME" /bin/bash
    exit 0
fi

echo "==> The container was not found. Installing Docker and deploying Kali..."

echo "==> Updating information about packages..."
sudo apt update

echo "==> Checking whether Docker is installed..."
if ! command -v docker &>/dev/null; then
    echo "==> Installing Docker..."
    sudo apt install -y docker.io
    sudo systemctl enable --now docker
else
    echo "==> Docker is already installed."
fi

echo "==> Downloading the Kali Linux ARM64 image..."
sudo docker pull kalilinux/kali-rolling

echo "==> Creating a directory for Kali data on the host..."
mkdir -p "$KALI_HOME"

echo "==> Creating and launching a new Kali Linux container..."
sudo docker run -it \
    --name "$CONTAINER_NAME" \
    --hostname kalibox \
    --restart unless-stopped \
    -v "$KALI_HOME":/root \
    kalilinux/kali-rolling \
    /bin/bash

echo "==> Your Kali inside Docker is ready! For future runs, just execute the script again."
