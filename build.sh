#!/bin/bash
set -e

green="\e[32m"
red="\e[31m"
default="\e[0m"
blue="\e[94m"


create_init() {
    [ -f __init__.py ] && rm __init__.py
    files=$(ls | grep -E "*\.py" | tr " " "\n")
    [ ! ${#files[0]} -gt 0 ] && echo -e "- ${red}$1 file is empty!${default}\n" && return 0

    touch '__init__.py'
    echo -e "${blue}*${default} creating __init__.py for $1"
    folders+=("$1")
    for file in ${files[@]}; do
        
        echo -e "${red}- ${default}Importing $file to $1"
        echo "from main.$1.${file::-3} import *" | tee -a __init__.py >> /dev/null
    done
    echo -e "${green}+ ${default}done!\n"
}

create_init_for_dir() {
    [ -d $1 ] && cd $1 && create_init $1 && cd ..
}

[ ! -d main ] && echo "<main> directory not found." && exit
cd main
create_init_for_dir routes
create_init_for_dir models
create_init_for_dir forms
echo -e "created __init__.py files for: ${blue}${folders[@]}${default}"