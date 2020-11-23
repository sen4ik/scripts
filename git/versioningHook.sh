#/bin/sh
commitsCount=$(git log master --pretty=oneline | wc -l | xargs)
lastCommitHash=$(git log -n1 --format="%h")
version="v2.${commitsCount} (${lastCommitHash})"
echo $version > version.txt
git add version.txt
git commit -m 'update version.txt'
# git commit --allow-empty -m 'push to execute post-receive'
echo "update version successful"

#rev=$(git rev-parse HEA)
#echo $rev >> version.txt
