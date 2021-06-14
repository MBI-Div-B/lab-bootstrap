HOSTNAME=angstrom.hhg.lab
USERNAME=labadm
FOLDER="Repos/Mirrors"

for repo in `ssh ${USERNAME}@${HOSTNAME} "cd ${FOLDER};ls -d pytango*"`
do
    echo "found repository ${repo}"
    GITCLONEURL="ssh://${USERNAME}@${HOSTNAME}:/home/${USERNAME}/${FOLDER}/${repo}"
    git clone $GITCLONEURL
    echo ""
done
