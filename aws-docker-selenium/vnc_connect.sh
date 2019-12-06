#!/bin/bash
OPTIONS=()
VNCDEFAULTPASS="secret"

createmenu () {
# echo "Size of array: $#"
# echo "$@"
select option; do # in "$@" is the default
    if [ "$REPLY" -eq "$#" ];
    then
        echo "Exiting..."
        break;
    elif [ 1 -le "$REPLY" ] && [ "$REPLY" -le $(($#-1)) ];
    then
        # echo "You selected $option which is option $REPLY"
        
        if [[ $option == "Exit" ]]
        then
            echo "Exiting..."
            break;
        fi
        
        echo "You selected $option"
        
        options=( $option )
              # echo "IP '${options[0]}'" 
              echo "$VNCDEFAULTPASS" | vncviewer -autopass ${options[0]}:0
              break;
        else
              echo "Incorrect Input: Select a number 1-$#"
        fi
done
}

for CONTID in $(sudo docker ps -q) ; do
    CONTIP=$(sudo docker inspect --format '{{ .NetworkSettings.IPAddress }}' $CONTID)
    CONTNAME=$(sudo docker inspect --format '{{ .Name }}' $CONTID)
    
    if [[ $CONTNAME != *"hub"* ]]
    then
        OPTIONS+=("$CONTIP $CONTNAME $CONTID")
    fi
done

OPTIONS+=("Exit")

createmenu "${OPTIONS[@]}"

