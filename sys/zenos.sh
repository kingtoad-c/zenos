#!/bin/bash

curl -L https://aka.ms/install-dotnet-preview -o install-dotnet-preview.sh
sudo bash install-dotnet-preview.sh

cd ..
mkdir user
cd user
mkdir root
cd root

clear

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
RESET='\033[0m'

# ZenOS ASCII Logo
ZEN_LOGO="
${CYAN}███████╗███████╗████████╗███████╗ ██████╗ ███████╗
╚══███╔╝██╔════╝╚══██╔══╝██╔════╝██╔══██╗██╔════╝
  ███╔╝ █████╗     ██║   █████╗  ██████╔╝███████╗
 ███╔╝  ██╔══╝     ██║   ██╔══╝  ██╔══██╗╚════██╗
███████╗███████╗    ██║   ███████╗██║  ██║███████╗
╚══════╝╚══════╝    ╚═╝   ╚══════╝╚═╝  ╚═╝╚══════╝${RESET}
"

# Matrix-style loading animation
matrix_loading() {
    clear
    echo -e "${GREEN}"
    for i in {1..30}; do
        line=""
        for j in {1..60}; do
            char=$(printf "\\x$(printf %x $((RANDOM % 26 + 65)))")
            line+="$char"
        done
        echo "$line"
        sleep 0.05
    done
    echo -e "${RESET}"
}

# Start
clear
matrix_loading
echo -e "$ZEN_LOGO"
echo -e "${CYAN}Booting ZenOS...${RESET}"
sleep 2
clear
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
            echo -e "  help      - Show this help message"
            echo -e "  date      - Show current date/time"
            echo -e "  about     - Info about ZenOS"
            echo -e "  clear     - Clear the screen"
            echo -e "  reboot    - Restart ZenOS shell"
            echo -e "  shutdown  - Exit ZenOS shell"
            echo -e "  games     - Launch ZenOS Game Center"
            ;;
        date)
            date
            ;;
        about)
            echo -e "${GREEN}ZenOS v1.0 - A sleek, minimal terminal OS experience${RESET}"
            echo -e "Made with 💻 by Alfiehart & ZenTech"
            ;;
        clear)
            clear
            ;;
        reboot)
            echo -e "${GREEN}Rebooting ZenOS...${RESET}"
            exec "$0"
            ;;
        shutdown)
            echo -e "${GREEN}Shutting down ZenOS. Goodbye!${RESET}"
            exit 0
            ;;
        games)
            while true; do
                echo -e "${CYAN}--- ZenOS Game Center ---${RESET}"
                echo -e "1) Guess the Number"
                echo -e "2) Rock-Paper-Scissors"
                echo -e "3) Even or Odd"
                echo -e "4) Dice Roll Battle"
                echo -e "5) Quick Math Quiz"
                echo -e "9) 3D Ray Tracing Demo (C#)"
                echo -e "6) Exit Games"
                echo -n "Choose a game: "
                read game_choice

                case $game_choice in
                    1)
                        number=$(( RANDOM % 100 + 1 ))
                        tries=0
                        echo -e "${MAGENTA}Guess the Number (1-100):${RESET}"
                        while true; do
                            read -p "Your guess: " guess
                            ((tries++))
                            if [[ $guess -eq $number ]]; then
                                echo -e "${GREEN}Correct in $tries tries!${RESET}"
                                break
                            elif [[ $guess -lt $number ]]; then
                                echo -e "${CYAN}Too low.${RESET}"
                            else
                                echo -e "${CYAN}Too high.${RESET}"
                            fi
                        done
                        ;;
                    2)
                        options=("rock" "paper" "scissors")
                        comp=${options[$RANDOM % 3]}
                        echo -n "Choose rock, paper, or scissors: "
                        read user
                        echo "Computer chose: $comp"
                        if [[ $user == $comp ]]; then
                            echo -e "${MAGENTA}It's a tie!${RESET}"
                        elif [[ ($user == "rock" && $comp == "scissors") || 
                                ($user == "paper" && $comp == "rock") || 
                                ($user == "scissors" && $comp == "paper") ]]; then
                            echo -e "${GREEN}You win!${RESET}"
                        else
                            echo -e "${RED}You lose!${RESET}"
                        fi
                        ;;
                    3)
                        num=$(( RANDOM % 100 + 1 ))
                        echo -n "Even or Odd? "
                        read guess
                        if (( num % 2 == 0 )); then
                            correct="even"
                        else
                            correct="odd"
                        fi
                        echo "Number: $num"
                        [[ $guess == $correct ]] && echo -e "${GREEN}Correct!${RESET}" || echo -e "${RED}Wrong!${RESET}"
                        ;;
                    4)
                        u=$(( RANDOM % 6 + 1 ))
                        c=$(( RANDOM % 6 + 1 ))
                        echo "You rolled: $u"
                        echo "Computer rolled: $c"
                        [[ $u -gt $c ]] && echo -e "${GREEN}You win!${RESET}" || [[ $u -lt $c ]] && echo -e "${RED}Computer wins!${RESET}" || echo -e "${MAGENTA}Tie!${RESET}"
                        ;;
                    5)
                        a=$(( RANDOM % 10 + 1 ))
                        b=$(( RANDOM % 10 + 1 ))
                        echo -n "What is $a + $b? "
                        read ans
                        [[ $ans -eq $((a + b)) ]] && echo -e "${GREEN}Correct!${RESET}" || echo -e "${RED}Wrong!${RESET}"
                        ;;
                    9)
                        echo -e "${CYAN}Launching 3D Ray Tracing Demo...${RESET}"
						cd ..
						cd ..
						cd sys
                        ls
                        dotnet /datac/bin/Debug/net9.0/datac.dll
                        cd ..
                        cd user
                        cd root
                        ;;
                    6)
                        echo -e "${CYAN}Exiting games...${RESET}"
                        break
                        ;;
                    *)
                        echo -e "${RED}Invalid choice.${RESET}"
                        ;;
                esac
                echo
            done
            ;;
        *)

if [ "$cmd" == "ls" ]; then
    echo "ls"
    ls
elif command -v "$cmd" &> /dev/null; then
    $cmd
else
    echo -e "${RED}Command '$cmd' not found.${RESET}"
    echo -e "trying os - output:"
    $cmd
fi
;;
    esac
done
