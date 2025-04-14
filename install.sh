#This script was created by TheDasshu

#!/bin/bash

# Colors
red='\033[1;31m'
green='\033[1;32m'
blue='\033[1;34m'
yellow='\033[1;33m'
white='\033[1;37m'
reset='\033[0m'

# Spinner function
spinner() {
    local pid=$!
    local spin='-\|/'
    local i=0
    while kill -0 $pid 2>/dev/null; do
        i=$(( (i+1) %4 ))
        printf "\r${yellow}Installing... ${spin:$i:1}${reset}"
        sleep .1
    done
    echo ""
}

# Detect Package Manager
if command -v apt >/dev/null; then
    PKG="apt"
elif command -v pkg >/dev/null; then
    PKG="pkg"
else
    echo -e "${red}[!] Unsupported package manager.${reset}"
    exit 1
fi

# Banner
clear
echo -e "${blue}"
echo "████████╗ ██████╗  ██████╗ ██╗     ██╗███╗   ██╗███████╗██╗   ██╗"
echo "╚══██╔══╝██╔═══██╗██╔═══██╗██║     ██║████╗  ██║██╔════╝╚██╗ ██╔╝"
echo "   ██║   ██║   ██║██║   ██║██║     ██║██╔██╗ ██║█████╗   ╚████╔╝ "
echo "   ██║   ██║   ██║██║   ██║██║     ██║██║╚██╗██║██╔══╝    ╚██╔╝  "
echo "   ██║   ╚██████╔╝╚██████╔╝███████╗██║██║ ╚████║███████╗   ██║   "
echo "   ╚═╝    ╚═════╝  ╚═════╝ ╚══════╝╚═╝╚═╝  ╚═══╝╚══════╝   ╚═╝   "
echo -e "${green}                    ~By Dasshu as D-Script! | Kali | Termux | Parrot${reset}"
echo -e "${blue}==================================================================${reset}"

# Mode Options
echo -e "${white}\nChoose installation mode:"
echo -e "${green}[1] --> Some of The Most Important Packages [30% Tools]"
echo -e "[2] --> Most of the Necessary Packages for All Tools [70% Tools]"
echo -e "[3] --> Full toolset + Networking Tools [100% Tools]${reset}"
read -p $'\nEnter your choice [1/2/3]: ' choice

update_system() {
    echo -e "\n${yellow}[+] Updating system...${reset}"
    $PKG update -y >/dev/null && $PKG upgrade -y >/dev/null &
    spinner
    echo -e "${green}[✓] System updated.${reset}"
}

install_packages() {
    for pkg in "$@"; do
        echo -e "${blue}[+] Installing $pkg...${reset}"
        $PKG install -y $pkg >/dev/null 2>>error.log &
        spinner
        if [ $? -eq 0 ]; then
            echo -e "${green}[✓] $pkg installed successfully.${reset}"
        else
            echo -e "${red}[x] Failed to install $pkg. Check error.log.${reset}"
        fi
    done
}

update_system

case $choice in
    1)
        install_packages python curl openssh git wget nano bash tar zip unzip pip clang proot termux-api
        ;;
    2)
        install_packages python curl openssh git wget nano bash tar zip unzip pip clang proot termux-api \
        ruby perl dnsutils php nmap net-tools nodejs coreutils util-linux binutils figlet
        ;;
    3)
        install_packages python curl openssh git wget nano bash tar zip unzip pip clang proot termux-api \
        ruby perl dnsutils php nmap net-tools nodejs coreutils util-linux binutils figlet \
        htop neofetch iproute2 iputils-ping netcat ifconfig traceroute whois tcpdump aircrack-ng
        ;;
    *)
        echo -e "${red}[!] Invalid option. Exiting.${reset}"
        exit 1
        ;;
esac

echo -e "\n${green}[✓] Installation Complete!${reset}"
echo -e "${yellow}[*] Check 'error.log' if any package failed."
echo -e "${blue}Thanks for using TOOL-INSTALLER by Dasshu!${reset}"