#!/bin/bash

# Color definitions
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
MAGENTA='\033[1;35m'
CYAN='\033[1;36m'
WHITE='\033[1;37m'
RESET='\033[0m'

# Auto System Update & Upgrade on Start
echo -e "${CYAN}[+] Updating and upgrading your system before starting TOOLINY...${RESET}"
detect_package_manager
if $UPDATE_CMD >/dev/null 2>&1; then
    echo -e "${GREEN}[✓] System update and upgrade completed. :))${RESET}"
else
    echo -e "${RED}[✗] System update failed.${RESET}"
fi

# Detect package manager
detect_package_manager() {
    if command -v apt >/dev/null 2>&1; then
        PKG_MANAGER="apt"
        INSTALL_CMD="apt install -y"
        UPDATE_CMD="apt update -y && apt upgrade -y"
        CLEAN_CMD="apt clean && apt autoclean"
        FIX_CMD="apt --fix-broken install -y"
        CHECK_INSTALLED_CMD="dpkg -s"
    elif command -v pacman >/dev/null 2>&1; then
        PKG_MANAGER="pacman"
        INSTALL_CMD="pacman -S --noconfirm"
        UPDATE_CMD="pacman -Syu --noconfirm"
        CLEAN_CMD="pacman -Sc --noconfirm"
        FIX_CMD="pacman -Syyu --noconfirm"
        CHECK_INSTALLED_CMD="pacman -Qi"
    elif command -v pkg >/dev/null 2>&1; then
        PKG_MANAGER="pkg"
        INSTALL_CMD="pkg install -y"
        UPDATE_CMD="pkg update -y && pkg upgrade -y"
        CLEAN_CMD="pkg clean"
        FIX_CMD="pkg install -f"
        CHECK_INSTALLED_CMD="dpkg -s"
    else
        echo -e "${RED}[!] Unsupported package manager.${RESET}"
        exit 1
    fi
}

# Check if a package is installed
is_installed() {
    if $CHECK_INSTALLED_CMD "$1" >/dev/null 2>&1; then
        return 0
    else
        return 1
    fi
}

# Install packages with progress
install_packages() {
    for pkg in "$@"; do
        if is_installed "$pkg"; then
            echo -e "${YELLOW}[!] ${pkg} is already installed.${RESET}"
        else
            echo -e "${CYAN}[+] Installing ${pkg}...${RESET}"
            if $INSTALL_CMD "$pkg" >/dev/null 2>&1; then
                echo -e "${GREEN}[✓] ${pkg} installed successfully.${RESET}"
            else
                echo -e "${RED}[✗] Failed to install ${pkg}.${RESET}"
            fi
        fi
    done
}

# Update system
update_system() {
    echo -e "${CYAN}[+] Updating system...${RESET}"
    if $UPDATE_CMD >/dev/null 2>&1; then
        echo -e "${GREEN}[✓] System updated successfully.${RESET}"
    else
        echo -e "${RED}[✗] System update failed.${RESET}"
    fi
}

# Repair system
repair_system() {
    echo -e "${CYAN}[+] Repairing system...${RESET}"
    if $FIX_CMD >/dev/null 2>&1; then
        echo -e "${GREEN}[✓] System repaired successfully.${RESET}"
    else
        echo -e "${RED}[✗] System repair failed.${RESET}"
    fi
}

# Update TOOLINY
update_tooliny() {
    echo -e "${CYAN}[+] Updating TOOLINY...${RESET}"
    cd ~ || exit
    rm -rf tooliny
    if git clone https://github.com/thedasshu/tooliny.git >/dev/null 2>&1; then
        cd tooliny || exit
        chmod +x install.sh
        apt install dos2unix
        dos2unix install.sh
        bash install.sh
        echo -e "${GREEN}[✓] TOOLINY updated and restarted.${RESET}"
        exit 0
    else
        echo -e "${RED}[✗] Failed to update TOOLINY.${RESET}"
    fi
}

# Contact information
contact_info() {
    echo -e "${BLUE}Contact Us:${RESET}"
    echo -e "${GREEN}[1] Instagram - Main: ${WHITE}@thedasshu${RESET}"
    echo -e "${GREEN}[2] Instagram - Private: ${WHITE}@artistdasshu${RESET}"
    echo -e "${GREEN}[3] Telegram Group: ${WHITE}https://t.me/hackerschatbox${RESET}"
    read -rp "Select contact option [1-3]: " contact
    case $contact in
        1) xdg-open https://instagram.com/thedasshu ;;
        2) xdg-open https://instagram.com/artistdasshu ;;
        3) xdg-open https://t.me/hackerschatbox ;;
        *) echo -e "${RED}[!] Invalid selection.${RESET}" ;;
    esac
}

# Main menu
main_menu() {
    while true; do
    clear
        echo -e "${MAGENTA}┌────────────────────────────────────────┐"
        echo -e "│           ${WHITE}TOOLINY INSTALLER${MAGENTA}             │"
        echo -e "│      Created by ${GREEN}Dasshu${MAGENTA} for Hackers      │"
        echo -e "└────────────────────────────────────────┘${RESET}"
        echo -e "${CYAN}  Kali | Parrot | Arch | Google Shell | Termux \n ${RESET}"
        echo -e "${YELLOW}Select Installation Mode:${RESET}"
        echo -e "${GREEN}[1] Minimal Essentials (Core Tools - 30%)${RESET}"
        echo -e "${GREEN}[2] Necessary Environment (Most Required - 70%)${RESET}"
        echo -e "${GREEN}[3] Full Setup & Networking (Required tools - 100%)${RESET}"
        echo -e "${GREEN}[4] Check & Repair Package System (Fix Errors)${RESET}"
        echo -e "${GREEN}[5] Contact Us (Join our groups)${RESET}"
        echo -e "${GREEN}[6] Update TOOLINY Installer${RESET}"
        echo -e "${GREEN}[0] Exit Installer${RESET}"
        read -rp "Enter your choice [0-6]: " choice
        case $choice in
            1)
                install_packages python python2 python3 python3-pip python-pip curl openssh git wget nano bash tar zip unzip clang proot perl awk
                ;;
            2)
                install_packages python python2 python3 curl perl awk openssh git wget nano bash tar zip unzip clang proot \
                ruby perl dnsutils php nmap net-tools nodejs coreutils util-linux binutils figlet man iproute2 make
                ;;
            3)
                install_packages python python2 python3 curl openssh git wget nano bash tar zip unzip clang proot \
                ruby perl dnsutils php nmap net-tools nodejs coreutils util-linux ruby perl dnsutils php nmap net-tools nodejs coreutils util-linux binutils figlet man \
                curl tcpdump openssl wireshark-qt aircrack-ng hydra netcat traceroute nikto cmatrix toilet figlet netdiscover awk iproute2 free ufw tracepath ping finger
                ;;
                4)
                repair_system
                ;;
            5)
                contact_info
                ;;
            6)
                update_tooliny
                ;;
            0)
                echo -e "${CYAN}Thanks for using TOOLINY, the D-Script! Bye Dude ;)${RESET}"
                exit 0
                ;;
            *)
                echo -e "${RED}[!] Invalid choice. Please select a valid option.${RESET}"
                ;;
        esac
    done
}

# Run setup
clear
detect_package_manager
main_menu
