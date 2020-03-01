#!/bin/bash
BODY=$(curl -i 'http://149.56.10.110:5080/openmeetings/services/user/login?&user=sen4ik&pass=buRUza394')
echo "BODY: ${BODY}"
JSON=$(echo $BODY | sed '/d:/s/, d:[^}]*/ /')
echo "JSON: ${JSON}"
JSONTRIMMED=$(echo $JSON | sed 's/ //g')
echo "JSON TRIMMED: ${JSONTRIMMED}"
OMFILE=/var/www/html/getMeOM.php
echo "<html><body>${JSONTRIMMED}<body></html>" | sudo tee $OMFILE