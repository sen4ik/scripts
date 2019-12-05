#!/bin/bash
#!/bin/bash
for CONTID in $(sudo docker ps -q) ; do
    CONTIP=$(sudo docker inspect --format '{{ .NetworkSettings.IPAddress }}' $CONTID)
    CONTNAME=$(sudo docker inspect --format '{{ .Name }}' $CONTID)
    echo "$CONTID $CONTNAME $CONTIP"
done

