#!/usr/bin/env bash 

#set -eo pipefail

# color formatting

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' 

# Clone the git repo.
function clone_repo () {

    local TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
    GIT_REPO="Bitbucket_$TIMESTAMP"

    if mkdir $GIT_REPO/; then
        echo -e "${YELLOW}'$GIT_REPO' created successfully!${NC}\n"
    else
        echo "failed to create repo, exiting..."
        exit 1
    fi

    echo -e "Enter the git url to clone from:"
    read GIT_URL
    if cd $GIT_REPO; then
        echo -e "\nMoving into '$GIT_REPO'...\n"
    else
        echo -e "failed to move in '$GIT_REPO', exiting..."
    fi

    if git clone $GIT_URL; then
        echo -e "\n${YELLOW}Cloning successfull!${NC}\n"
    else
        echo -e "${RED}Cloning failed!!${NC}"
        echo "Exiting the script..."
        exit 1 
    fi

}

# Checkout to the branch and pull the latest changes

function pull_latest() {
    
    if cd */; then
        echo -e "Moving in '$(pwd)'\n"
    else
        echo -e "failed to move in '$(ls)'\n"
        exit 1
    fi


    echo -e "${YELLOW}proceeding with checkout...${NC}\n"
    echo -e "Enter the branch name :"
    read BRANCH

    if git checkout $BRANCH; then
        echo -e "\n${YELLOW}Pulling latest changes... ${NC}\n"
        git pull
    else
        echo -e "failed to checkout to '$BRANCH'\n"
        exit 1
    fi

}

# copy the deployment patches to the git repo.

function push_changes() {

    while true; do
        echo -e "\nAdd the ACS patch folder to be deployed in the repository and enter "y" to continue to check out or "q" to quit."
        read INPUT
        input_lower=$(echo "$INPUT" | tr '[:upper:]' '[:lower:]')
        
        if [ "$input_lower" == "y" ]; then
            if git add . ; then
                git status
                echo -e "${YELLOW}commiting the changes with message: "$BRANCH ${NC}"" 
                sleep .5
                git commit -m "$BRANCH"
                if git push; then
                    break
                fi
            else
                echo -e "failed to checkout to '$BRANCH'\n"
            fi
        elif [ "$input_lower" == "q" ]; then
            echo "quitting..."
            break
        else
            echo -e "Invalid input, please try again!"
        fi
    done
}

# main
echo -e "\n${GREEN}\t########## Script starts #########\t${NC}\n" && clone_repo  && pull_latest && push_changes && echo -e "\n${GREEN}\t########## Script was successfull! ##########\t${NC}\n"
