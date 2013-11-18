N=${BUILD_EXECUTOR:-1}
cd $(dirname $0)
WORKSPACE=$(pwd)
SALT_CLOUD=${SALT_CLOUD_PATH:-/home/jenkins/virtual/bin/salt-cloud}
SALT_CLOUD_OPTS="--profiles=${WORKSPACE}/jenkins.profiles --map=${WORKSPACE}/jenkins.map"
SSH_OPTS='-t -t -oStrictHostKeyChecking=no -oUserKnownHostsFile=/dev/null -oControlPath=none -oPasswordAuthentication=no -oChallengeResponseAuthentication=no -oPubkeyAuthentication=yes -oKbdInteractiveAuthentication=no'
STATUS=${WORKSPACE}/status-${N}.yaml

msg() {
  echo "$BUILD_ID [ $(date) ] === ${1}"
}

check_status() {
  sudo ${SALT_CLOUD} ${SALT_CLOUD_OPTS} -F --out=yaml 2>/dev/null > ${STATUS}
  python ${WORKSPACE}/parse.py -f ${STATUS} $1 > /dev/null
  echo $?
}

[ "${SALT_CLOUD_KEY_PATH}" == "" ] && echo "ERROR: please provide the path to your private_key file as SALT_CLOUD_KEY_PATH (as used in your provider definition)" && exit 4
[ ! -f "${SALT_CLOUD_KEY_PATH}" ] && echo "ERROR: cannot open private_key file ${SALT_CLOUD_KEY_PATH}" && exit 3

check_status all_up

# status should be good usable here
MASTER=$(python ${WORKSPACE}/parse.py -f ${STATUS} master_ip)
SLAVE=$(python ${WORKSPACE}/parse.py -f ${STATUS} first_slave_ip)

msg "List java processes on the master"
sudo ssh $SSH_OPTS -i ${SALT_CLOUD_KEY_PATH} ec2-user@${MASTER} 'ps -C java -o user,pid,pcpu'
msg "List java processes on the first slave"
sudo ssh $SSH_OPTS -i ${SALT_CLOUD_KEY_PATH} ec2-user@${SLAVE} 'ps -C java -o user,pid,pcpu'
