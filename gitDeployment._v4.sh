#!/usr/bin/env bash

# color formatting
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

# Declare global variables to be shared between functions
GIT_REPO=""
GIT_URL=""
BRANCH=""

# Clone the git repo.
function clone_repo () {
    echo -e "Enter the git url to clone from:"
    read GIT_URL

    local TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
    GIT_REPO="Bitbucket_$TIMESTAMP"

    if mkdir "$GIT_REPO"; then
        echo -e "${YELLOW}'$GIT_REPO' created successfully!${NC}\n"
    else
        echo "failed to create repo, exiting..."
        exit 1
    fi

    if cd "$GIT_REPO"; then
        echo -e "\nMoving into '$GIT_REPO'...\n"
    else
        echo -e "failed to move in '$GIT_REPO', exiting..."
        exit 1
    fi
    
    # Get the repository name from the URL to enter the correct directory
    local REPO_NAME=$(basename "$GIT_URL" .git)

    if git clone "$GIT_URL"; then
        echo -e "\n${YELLOW}Cloning successful!${NC}\n"
        if cd "$REPO_NAME"; then
            echo -e "Moved into '$REPO_NAME'...\n"
        else
            echo -e "Failed to move into '$REPO_NAME', exiting..."
            exit 1
        fi
    else
        echo -e "${RED}Cloning failed!!${NC}"
        echo "Exiting the script..."
        exit 1
    fi
}

# Checkout to the branch and pull the latest changes
function pull_latest() {
    echo -e "${YELLOW}Proceeding with checkout...${NC}\n"
    echo -e "Enter the branch name :"
    read BRANCH

    if git checkout "$BRANCH"; then
        echo -e "\n${YELLOW}Pulling latest changes... ${NC}\n"
        git pull
        echo -e "${GREEN}Pulling complete!${NC}"
    else
        echo -e "${RED}Failed to checkout to '$BRANCH'${NC}\n"
        exit 1
    fi
}

# copy the deployment patches to the git repo.
function push_changes() {
    while true; do
        echo -e "\nAdd the ACS patch folder to be deployed in the repository and enter 'y' to continue or 'q' to quit."
        read INPUT
        input_lower=$(echo "$INPUT" | tr '[:upper:]' '[:lower:]')

        if [ "$input_lower" == "y" ]; then
            if git add . ; then
                git status
                echo -e "${YELLOW}Committing the changes with message: '$BRANCH'${NC}"
                sleep 0.5
                git commit -m "$BRANCH"
                if git push; then
                    echo -e "${GREEN}Push successful!${NC}"
                    break
                else
                    echo -e "${RED}Push failed!${NC}"
                    exit 1
                fi
            else
                echo -e "${RED}Failed to add files to staging area!${NC}\n"
                exit 1
            fi
        elif [ "$input_lower" == "q" ]; then
            echo "Quitting..."
            break
        else
            echo -e "${RED}Invalid input, please try again!${NC}"
        fi
    done
}

# Run all functions sequentially
function run_all() {
    echo -e "\n${GREEN}\t########## Script starts #########\t${NC}\n"
    clone_repo && pull_latest && push_changes
    echo -e "\n${GREEN}\t########## Script was successful! ##########\t${NC}\n"
}

# Function to display the menu
function show_menu() {
    clear
    echo "=========================================="
    echo "         GIT OPERATIONS MENU"
    echo "=========================================="
    echo "1) Clone Repository"
    echo "2) Pull Latest Changes"
    echo "3) Push Changes"
    echo "4) Run All Operations (Clone -> Pull -> Push)"
    echo "q) Quit"
    echo "=========================================="
    echo -n "Enter your choice: "
}

# Main script loop
function main() {
    while true
    do
        show_menu
        read choice
        case "$choice" in
            1)
                clone_repo
                echo "Press any key to return to the menu..."
                read -n 1 -s
                ;;
            2)
                pull_latest
                echo "Press any key to return to the menu..."
                read -n 1 -s
                ;;
            3)
                push_changes
                echo "Press any key to return to the menu..."
                read -n 1 -s
                ;;
            4)
                run_all
                echo "Press any key to return to the menu..."
                read -n 1 -s
                ;;
            q)
                echo "Quitting."
                exit 0
                ;;
            *)
                echo "Invalid choice. Please enter a valid option."
                echo "Press any key to continue..."
                read -n 1 -s
                ;;
        esac
    done
}

# Execute the main function to start the script
main
