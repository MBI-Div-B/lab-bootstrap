HOSTNAME=angstrom.hhg.lab
USERNAME=labadm
FOLDER="Repos/Mirrors/pytango"

mkdir bin
for REPO in `ssh ${USERNAME}@${HOSTNAME} "cd ${FOLDER};ls -d pytango*"`
do
    echo "found repository ${REPO}"
    SHORTREPO=${REPO%".git"}
    echo $SHORTREPO
    GITCLONEURL="ssh://${USERNAME}@${HOSTNAME}:/home/${USERNAME}/${FOLDER}/${REPO}"
    git clone $GITCLONEURL
    ds=${SHORTREPO#"pytango-"}
    echo $ds
    ln -s "../"${SHORTREPO}/${ds}".py" bin/$ds
    echo ""

done
