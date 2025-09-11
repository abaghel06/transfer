#!/usr/bin/env bash


# Color formatting
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

# Check for required tools
function check_dependencies() {
    if ! command -v git &> /dev/null; then
        echo -e "${RED}Error: git is not installed. Please install git and try again.${NC}"
        exit 1
    fi
}

# Clone the git repo
function clone_repo() {
    local timestamp=$(date +"%Y-%m-%d_%H-%M-%S")
    local repo_dir="bitbucket_clone_$timestamp"

    echo -e "Enter the Git URL to clone from:"
    read -r git_url

    if [[ -z "$git_url" ]]; then
        echo -e "${RED}Error: Git URL cannot be empty. Exiting.${NC}"
        exit 1
    fi

    echo -e "\nAttempting to clone '$git_url' into a new directory: '$repo_dir'...\n"
    
    if git clone "$git_url" "$repo_dir"; then
        echo -e "\n${GREEN}Cloning successful!${NC}\n"
        cd "$repo_dir" || exit 1
    else
        echo -e "${RED}Error: Cloning failed. Please check the URL and your permissions.${NC}"
        exit 1
    fi
}

# Checkout to the branch and pull the latest changes
function pull_latest() {
    echo -e "${YELLOW}Proceeding with checkout...${NC}"
    echo -e "Enter the branch name (e.g., main, develop):"
    read -r branch

    if [[ -z "$branch" ]]; then
        echo -e "${RED}Error: Branch name cannot be empty. Exiting.${NC}"
        exit 1
    fi

    echo -e "Checking out to branch '${branch}'..."
    if git checkout "$branch"; then
        echo -e "\n${YELLOW}Pulling latest changes...${NC}"
        if git pull; then
            echo -e "${GREEN}Pull successful!${NC}"
        else
            echo -e "${RED}Warning: Pull failed. There may be conflicts or no upstream branch.${NC}"
        fi
    else
        echo -e "${RED}Error: Failed to checkout to branch '${branch}'. Please check the branch name.${NC}"
        exit 1
    fi
}

# Commit and push changes
function push_changes() {
    echo -e "\n${YELLOW}Detecting changes to commit...${NC}"

    if ! git diff --exit-code --quiet; then
        git status

        while true; do
            read -p "Do you want to commit and push these changes? (y/n): " -n 1 -r REPLY
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                echo -e "\n${YELLOW}Adding and committing changes...${NC}"
                git add .
                git commit -m "Deployment patch for branch: $branch"
                
                echo -e "\n${YELLOW}Pushing changes to remote...${NC}"
                if git push; then
                    echo -e "\n${GREEN}Push successful!${NC}"
                    break
                else
                    echo -e "${RED}Error: Push failed. Please resolve conflicts or check your credentials.${NC}"
                    exit 1
                fi
            elif [[ $REPLY =~ ^[Nn]$ ]]; then
                echo -e "${YELLOW}Aborting push. Changes are not committed or pushed.${NC}"
                break
            else
                echo -e "${RED}Invalid input. Please enter 'y' or 'n'.${NC}"
            fi
        done
    else
        echo -e "${YELLOW}No changes detected. Nothing to commit or push.${NC}"
    fi
}

# Main script logic
main() {
    echo -e "\n${GREEN}\t########## Git Deployment Script Starts ##########\t${NC}\n"
    
    check_dependencies
    clone_repo
    pull_latest
    push_changes
    
    echo -e "\n${GREEN}\t########## Script Finished Successfully! ##########\t${NC}\n"
}

main
