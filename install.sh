#!/bin/bash

# Colors
violet='\033[1;35m'  
purple='\033[0;35m'  
pink='\033[1;95m'    
reset='\033[0m'      
red='\033[1;31m'
green='\033[1;32m'
blue='\033[1;34m'
yellow='\033[1;33m'
white='\033[1;37m'

# Detect Package Manager
if command -v apt >/dev/null; then
    PKG="apt"
elif command -v pkg >/dev/null; then
    PKG="pkg"
else
    echo -e "${red}[!] Unsupported package manager.${reset}"
    exit 1
fi

# Spinner Animation
spinner() {
    local pid=$!
    local delay=0.1
    local spinstr='|/-\\'
    while ps a | awk '{print $1}' | grep -q "$pid"; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}

# Update System Silently
update_system() {
    echo -e "\n${yellow}[+] Updating system...${reset}"
    { $PKG update -y && $PKG upgrade -y; } >/dev/null 2>&1 & spinner
    echo -e "${green}[✓] System updated.${reset}"
}

# Install Packages with Progress Bar
install_packages() {
    for pkg in "$@"; do
        echo -e "${yellow}[+] Installing ${pkg}...${reset}"

progress=0
{
    $PKG install -y "$pkg" 2>/dev/null
} | while IFS= read -r line; do
    progress=$((progress + 1))
    percent=$(( (progress * 5) % 101 ))
    bar=$(printf "%0.s#" $(seq 1 $((percent / 5))))
    printf "\r${blue}[%-20s] %3d%%${reset}" "$bar" "$percent"
    sleep 0.05
done
        if $PKG install -y "$pkg" >/dev/null 2>&1; then
            echo -e "\r${green}[✓] ${pkg} installed successfully!${reset}                        "
        else
            echo -e "\r${red}[✗] Failed to install ${pkg}.${reset}                          "
        fi
    done
}

# Fix and Repair Broken Mirrors/Packages
repair_system() {
    echo -e "${yellow}[+] Repairing and cleaning package system...${reset}"
    {
        rm -rf $PREFIX/var/lib/apt/lists/*
        $PKG clean
        $PKG autoclean
        $PKG update -y && $PKG upgrade -y --fix-missing --allow-unauthenticated
    } >/dev/null 2>&1 & spinner
    echo -e "${green}[✓] Repair and cleanup completed.${reset}"
}

# Contact Info Display with Redirect Options
contact_info() {
    clear
    echo -e "${blue}=============================="
    echo -e "       CONTACT US -  D-Script! "
    echo -e "==============================${reset}"
    echo -e "${green}[1] Instagram - Main: ${white}@the_dasshu"
    echo -e "${green}[2] Instagram - Private: ${white}@artistdasshu"
    echo -e "${green}[3] Telegram Group: ${white}https://t.me/hackerschatbox${reset}"
    echo -e "\n${yellow}We’re here to help you anytime!${reset}"
    read -p $'\nSelect contact option [1-3]: ' contact
    case $contact in
        1) termux-open-url https://instagram.com/the_dasshu ;;
        2) termux-open-url https://instagram.com/artistdasshu ;;
        3) termux-open-url https://t.me/hackerschatbox ;;
        *) echo -e "${red}[!] Invalid selection.${reset}" ;;
    esac
}

# Start Loop
while true; do
    clear
    echo -e "${blue}┌────────────────────────────────────────┐"
    echo -e "│           ${white}TOOLINY INSTALLER${blue}             │"
    echo -e "│      Created by ${green}Dasshu${blue} for Hackers      │"
    echo -e "└────────────────────────────────────────┘${reset}\n"
    echo -e "         ${pink} •>> ${reset}${violet}Ubuntu | Kali | Termux | Parrot OS${reset}${pink} <<• ${reset}"
    echo -e " \n"
    echo -e "${yellow}Select Installation Mode:${reset}"
    echo -e "${green}[1]--> Minimal Essentials Pkg   (Core Tools - 30%)"
    echo -e "[2]--> Necessary Environment (Most Required - 70%)"
    echo -e "[3]--> Full Setup & Networking (Required tools - 100%)"
    echo -e "[4]--> Check & Repair Package System (Fix Errors)"
    echo -e "[5]--> Contact Us (Join our groups)"
    echo -e "[0]--> Exit Installer${reset}"
    read -p $'\nEnter your choice [0-5]: ' choice

    update_system

    case $choice in
        1)
            install_packages python curl openssh git wget nano bash tar zip unzip python-pip clang proot termux-api
            ;;
        2)
            install_packages python curl openssh git wget nano bash tar zip unzip pip clang proot termux-api \
            ruby perl dnsutils php nmap net-tools nodejs coreutils util-linux binutils figlet man
            ;;
        3)
            install_packages python curl openssh git wget nano bash tar zip unzip pip clang proot termux-api \
            ruby perl dnsutils php nmap net-tools nodejs coreutils util-linux binutils figlet \
            htop man neofetch iproute2 iputils-ping netcat ifconfig traceroute whois tcpdump aircrack-ng
            ;;
        4)
            repair_system() {
    echo -e "${yellow}[+] Checking and repairing package system...${reset}"

    echo -e "${blue}[*] Cleaning up...${reset}"
    rm -rf $PREFIX/var/lib/apt/lists/* >/dev/null 2>&1
    $PKG clean >/dev/null 2>&1
    $PKG autoclean >/dev/null 2>&1

    echo -e "${blue}[*] Fixing broken installs...${reset}"
    dpkg --configure -a >/dev/null 2>&1
    apt --fix-broken install -y >/dev/null 2>&1

    echo -e "${blue}[*] Updating sources...${reset}"
    $PKG update -y >/dev/null 2>&1

    echo -e "${blue}[*] Upgrading packages...${reset}"
    $PKG upgrade -y --allow-unauthenticated >/dev/null 2>&1

    echo -e "${green}[✓] Package system repaired successfully!${reset}"
}
            ;;
        5)
            contact_info
            ;;
        0)
            echo -e "${green}[✓] Exiting D-Script. Goodbye!${reset}"
            break
            ;;
        *)
            echo -e "${red}[!] Invalid option. Try again.${reset}"
            ;;
    esac

    read -p $'\nPress Enter to return to the main menu...'
done
