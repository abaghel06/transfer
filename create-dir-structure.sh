#!/usr/bin/bash bash

# structure menu

function structure_menu_a() {
    clear
    echo "------------------------------------------"
    echo "         DEPLOYMENT TYPE?"
    echo "------------------------------------------"
    echo "1) DB"
    echo "2) DB + Patch"
    echo "s) Skip"
    echo "q) Quit"
    echo "------------------------------------------"
    echo -n "Enter your choice: "
}

function structure_menu_b() {
    echo "------------------------------------------"
    echo "         STRUCTURE MENU - B"
    echo "------------------------------------------"
    echo "1) KNIME"
    echo "2) Python"
    echo "q) Quit"
    echo "------------------------------------------"
    echo -n "Enter your choice: "
}

# create-folder

function create-folder() {
    target_path=$1
    if mkdir -p $target_path; then
        echo -e "$(basename $target_path) created at '$target_path' succesfully!"
    else
        echo -e "Failed to create $(basename $target_path) at $target_path'!"
    fi
}

# create-files

function create-file() {
    target_file=$1
    if touch $target_file; then
        echo -e "$(basename $target_file) created at '$target_file' succesfully!"
    else
        echo -e "Failed to create $(basename $target_file) at $target_file'!"
    fi
}

# prompt 1

function prompt_one() {
    while true
    do
        structure_menu_a
        read choice
        case "$choice" in
            1)
                create-folder $db_path && create-file $filelist
                prompt_two
                ;;
            2)
                create-folder $db_path && create-file $filelist
                create-folder $patches && create-file $patches_txt
                prompt_two
                ;;
            s)
                prompt_two
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

# prompt 2

function prompt_two() {
    while true
    do
        structure_menu_b
        read choice2
        case "$choice2" in
            1)
                echo -e "Finsap3 or FINSAP7? (enter 3 or 7):"
                read finsap

                if [[ $finsap==3 ]]; then
                    create-folder $knime_f3 && create-file $knime_workspaces_txt
                    echo "Press any key to continue..."
                    read -n 1 -s
                    exit 0
                else
                    create-folder $knime_f7 && create-file $knime_workspaces_txt
                    exit 0
                fi
                ;;
            2)
                while true; do
                    echo -e "Finsap3 or FINSAP7? (enter 3 or 7):"
                    read finsap
                    case "$finsap" in 
                        3)
                            echo -e "Done!"
                            echo "Press any key to continue..."
                            read -n 1 -s
                            exit 0
                            ;;
                        7)
                            create_folder $knime_f7
                            echo -e "Done!"
                            echo "Press any key to continue..."
                            read -n 1 -s
                            exit 0
                            ;;
                        *)
                            echo "invalid input"
                            ;;
                    esac
                done
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

# main 


echo -e "\nWorking in directory - '$(pwd)'"
echo -e "\nEnter ACS name : "

read fname

if [[ -n $fname ]] && create-folder $fname ; then

    # paths - folders
    db_path=$fname/db
    patches=$fname/patches
    knime_f3=$fname/knime-workspaces/Buissness-groups/GFT_FINSAP/FINSAP3/$fname
    knime_f7=$fname/knime-workspaces/Buissness-groups/GFT_FINSAP_FINANCE/FINSAP13/$fname
    
    # paths - files 
    filelist=$db_path/FileList.ctl
    patches_txt=$fname/patches.txt
    knime_workspaces_txt=$fname/knime-workspaces.txt
    prompt_one

else
    echo "exiting.."
    exit 1
fi

