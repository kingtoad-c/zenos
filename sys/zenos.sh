cd ..
mkdir user
cd user
mkdir root
cd root

clear

#!/bin/bash

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
RESET='\033[0m'

# ASCII Art for ZenOS Logo
ZEN_LOGO="
${CYAN}███████╗███████╗████████╗███████╗ ██████╗ ███████╗
╚══███╔╝██╔════╝╚══██╔══╝██╔════╝██╔══██╗██╔════╝
   ███╔╝ █████╗     ██║   █████╗  ██████╔╝███████╗
  ███╔╝  ██╔══╝     ██║   ██╔══╝  ██╔══██╗╚════██╗
███████╗███████╗    ██║   ███████╗██║  ██║███████╗
╚══════╝╚══════╝    ╚═╝   ╚══════╝╚═╝  ╚═╝╚══════╝
${RESET}
"

# Matrix-style animation function
matrix_effect() {
    local columns=$(tput cols)
    local lines=$(tput lines)
    local chars=(a b c d e f g h i j k l m n o p q r s t u v w x y z 0 1 2 3 4 5 6 7 8 9)
    
    tput civis  # hide cursor
    for ((i=0; i<50; i++)); do
        for ((j=0; j<columns; j++)); do
            char=${chars[$RANDOM % ${#chars[@]}]}
            printf "\033[%s;%sH${GREEN}%s${RESET}" "$((RANDOM % lines + 1))" "$j" "$char"
        done
        sleep 0.05
    done
    tput cnorm  # show cursor
    clear
}

# Clear screen and show ZenOS branding
clear
echo -e "${ZEN_LOGO}"
echo -e "${CYAN}Booting ZenOS...${RESET}"

# Wait a bit and show Matrix effect
sleep 2
matrix_effect


# Welcome screen
echo -e "${MAGENTA}Welcome to ZenOS!${RESET}"
echo -e "${MAGENTA}Type 'help' to get started.${RESET}"
echo

# Shell loop
while true; do
    current_dir=$(pwd)
    echo -n -e "${CYAN}[$current_dir]${RESET} ${GREEN}zen-os> ${RESET}"
    read cmd

    case "$cmd" in
        help)
            echo -e "${GREEN}Available commands:${RESET}"
            echo -e "  ${GREEN}help${RESET}      - Show this help message"
            echo -e "  ${GREEN}date${RESET}      - Show current system date and time"
            echo -e "  ${GREEN}about${RESET}     - Info about ZenOS"
            echo -e "  ${GREEN}clear${RESET}     - Clear the screen"
            echo -e "  ${GREEN}reboot${RESET}    - Reboot ZenOS"
            echo -e "  ${GREEN}shutdown${RESET}  - Exit ZenOS"
            echo -e "  ${GREEN}wifi${RESET}      - Connect to Wi-Fi"
            echo -e "  ${GREEN}games${RESET}     - Play terminal-based games"
            ;;
        date)
            date
            ;;
        about)
            echo -e "${GREEN}ZenOS v1.0 - A sleek, modern phone-like OS${RESET}"
            echo -e "Made with 💖 by ZenTech"
            ;;
        clear)
            clear
            ;;
        reboot)
            echo -e "${GREEN}Rebooting ZenOS...${RESET}"
            sudo reboot
            ;;
        shutdown)
            echo -e "${GREEN}Shutting down ZenOS...${RESET}"
            sudo shutdown now
            ;;
        wifi)
            echo -e "${CYAN}Scanning for Wi-Fi networks...${RESET}"

            if ! command -v nmcli &> /dev/null; then
                echo -e "${RED}Error: nmcli not found. Please ensure NetworkManager is installed.${RESET}"
                continue
            fi

            networks=$(nmcli dev wifi list)
            if [[ -z "$networks" ]]; then
                echo -e "${RED}No Wi-Fi networks found. Please check your Wi-Fi device.${RESET}"
                continue
            fi

            echo -e "${GREEN}$networks${RESET}"
            echo -e "${CYAN}Select a network by SSID (case-sensitive):${RESET}"
            read ssid

            if ! echo "$networks" | grep -q "$ssid"; then
                echo -e "${RED}Error: Network '$ssid' not found. Try again.${RESET}"
                continue
            fi

            echo -e "${CYAN}You selected $ssid. Please enter password:${RESET}"
            read -s password

            echo -e "${CYAN}Connecting to $ssid...${RESET}"
            nmcli dev wifi connect "$ssid" password "$password"

            if [[ $? -eq 0 ]]; then
                echo -e "${GREEN}Connected to $ssid successfully!${RESET}"
            else
                echo -e "${RED}Failed to connect to $ssid. Please check the password or network.${RESET}"
            fi
            ;;
        games)
            while true; do
                echo -e "${CYAN}--- ZenOS Game Center ---${RESET}"
                echo -e "1) Guess the Number"
                echo -e "2) Rock-Paper-Scissors"
                echo -e "3) Even or Odd"
                echo -e "4) Dice Roll Battle"
                echo -e "5) Quick Math Quiz"
                echo -e "6) Exit Games"
                echo -n "Choose a game: "
                read game_choice

                case $game_choice in
                    1) # Guess the Number
                        number=$(( RANDOM % 100 + 1 ))
                        tries=0
                        echo -e "${MAGENTA}Guess the Number (1-100):${RESET}"
                        while true; do
                            read -p "Your guess: " guess
                            ((tries++))
                            if [[ $guess -eq $number ]]; then
                                echo -e "${GREEN}You got it in $tries tries!${RESET}"
                                break
                            elif [[ $guess -lt $number ]]; then
                                echo -e "${CYAN}Too low.${RESET}"
                            else
                                echo -e "${CYAN}Too high.${RESET}"
                            fi
                        done
                        ;;

                    2) # Rock-Paper-Scissors
                        options=("rock" "paper" "scissors")
                        comp_choice=${options[$RANDOM % 3]}
                        echo -n "Choose rock, paper, or scissors: "
                        read user_choice
                        echo -e "Computer chose: ${comp_choice}"
                        if [[ $user_choice == $comp_choice ]]; then
                            echo -e "${MAGENTA}It's a tie!${RESET}"
                        elif [[ ($user_choice == "rock" && $comp_choice == "scissors") || 
                                ($user_choice == "paper" && $comp_choice == "rock") || 
                                ($user_choice == "scissors" && $comp_choice == "paper") ]]; then
                            echo -e "${GREEN}You win!${RESET}"
                        else
                            echo -e "${RED}You lose!${RESET}"
                        fi
                        ;;

                    3) # Even or Odd
                        num=$(( RANDOM % 100 + 1 ))
                        echo -n "Even or Odd? (type 'even' or 'odd'): "
                        read choice
                        if (( num % 2 == 0 )); then
                            correct="even"
                        else
                            correct="odd"
                        fi
                        echo -e "The number was $num."
                        if [[ $choice == $correct ]]; then
                            echo -e "${GREEN}Correct!${RESET}"
                        else
                            echo -e "${RED}Wrong, it was $correct.${RESET}"
                        fi
                        ;;

                    4) # Dice Roll Battle
                        user_roll=$(( RANDOM % 6 + 1 ))
                        comp_roll=$(( RANDOM % 6 + 1 ))
                        echo -e "You rolled: ${GREEN}$user_roll${RESET}"
                        echo -e "Computer rolled: ${RED}$comp_roll${RESET}"
                        if [[ $user_roll -gt $comp_roll ]]; then
                            echo -e "${GREEN}You win the battle!${RESET}"
                        elif [[ $user_roll -lt $comp_roll ]]; then
                            echo -e "${RED}Computer wins!${RESET}"
                        else
                            echo -e "${MAGENTA}It's a tie!${RESET}"
                        fi
                        ;;

                    5) # Quick Math Quiz
                        a=$(( RANDOM % 10 + 1 ))
                        b=$(( RANDOM % 10 + 1 ))
                        result=$(( a + b ))
                        echo -n "What is $a + $b? "
                        read answer
                        if [[ $answer -eq $result ]]; then
                            echo -e "${GREEN}Correct!${RESET}"
                        else
                            echo -e "${RED}Wrong! The answer was $result.${RESET}"
                        fi
                        ;;

                    6)
                        echo -e "${CYAN}Exiting games...${RESET}"
                        break
                        ;;

                    *)
                        echo -e "${RED}Invalid choice. Try again.${RESET}"
                        ;;
                esac
                echo
            done
            ;;
        *)
            if command -v "$cmd" &> /dev/null; then
                $cmd
            else
                $cmd
            fi
            ;;
    esac
done
