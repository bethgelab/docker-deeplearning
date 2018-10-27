echo "Start ssh daemon"
echo "${NB_USER}:pw" | chpasswd
/usr/sbin/sshd

GPFS_HOME="/gpfs01/bethge/home/${NB_USER}"
if [ -d "$GPFS_HOME" ]; then
    echo "Change home dir of user ${NB_USER} to $GPFS_HOME"
    usermod -d $GPFS_HOME ${NB_USER}
fi
