N=${BUILD_EXECUTOR:-1}
cd $(dirname $0)
WS=$(pwd)
SALT_CLOUD=${SALT_CLOUD_PATH:-/home/jenkins/virtual/bin/salt-cloud}
SALT_CLOUD_OPTS="--profiles=${WS}/jenkins.profiles --map=${WS}/jenkins.map"
SSH_OPTS='-t -t -oStrictHostKeyChecking=no -oUserKnownHostsFile=/dev/null -oControlPath=none -oPasswordAuthentication=no -oChallengeResponseAuthentication=no -oPubkeyAuthentication=yes -oKbdInteractiveAuthentication=no'
STATUS=${WS}/status-${N}.yaml

[ "${SALT_CLOUD_KEY_PATH}" == "" ] && echo "ERROR: please provide the path to your private_key file as SALT_CLOUD_KEY_PATH (as used in your provider definition)" && exit 4
[ ! -f "${SALT_CLOUD_KEY_PATH}" ] && echo "ERROR: cannot open private_key file ${SALT_CLOUD_KEY_PATH}" && exit 3

msg() {
  echo "$BUILD_ID [ $(date) ] === ${1}"
}

check_status() {
  sudo ${SALT_CLOUD} ${SALT_CLOUD_OPTS} -F --out=yaml 2>/dev/null > ${STATUS}
  python ${WS}/parse.py -f ${STATUS} $1 > /dev/null
  echo $?
}

start_map() {
  sudo ${SALT_CLOUD} ${SALT_CLOUD_OPTS} -y
}

destroy_map() {
  sudo ${SALT_CLOUD} ${SALT_CLOUD_OPTS} -d -y
}


msg "Checking for existing instances"
all_down=$(check_status all_down)

if [ $all_down -ne 0 ]
then
  msg "Hosts in map-${N} are still up - will destroy the map now"
  destroy_map
  all_down_again=$(check_status all_down)
  if [ $all_down_again -ne 0 ]
  then
    msg "Destroy was unsuccessful - exiting ..."
    exit 5
  fi
fi

msg "Starting map ${MAP} now"
start_map

all_up=127
attempts=0
max_attempts=3

while [ $all_up -eq 127 -a $attempts -le $max_attempts ]
do
  all_up=$(check_status all_up)
  let attempts=$attempts+1
  if [ $attempts -le $max_attempts ]
  then
    msg "Wait for 10 seconds before checking started instances again"
    sleep 10
  fi
done

if [ $all_up -ne 0 ]
then
  msg "Something went wrong - apparently not all machines are up"
  cat $STATUS
  exit 1
fi

# status should be good usable here
MASTER=$(python ${WS}/parse.py -f ${STATUS} master_ip)
SLAVE=$(python ${WS}/parse.py -f ${STATUS} first_slave_ip)
msg "The ip address of the master node appears to be ${MASTER}"
msg "The ip address of the first slave node appears to be ${SLAVE}"

[ "" == "$MASTER" ] && msg "Cannot determine the master IP - giving up" && exit 4 
[ "" == "$SLAVE" ] && msg "Cannot determine the slave IP - giving up" && exit 4 

msg "Adding the gitfs cache directory manually to fix the refresh lag"
sudo ssh $SSH_OPTS -i ${SALT_CLOUD_KEY_PATH} ec2-user@${MASTER} 'sudo mkdir -p /var/cache/salt/master/gitfs'
msg "Waiting for 1 minute for the remotes to materialize in the master cache"
sleep 60
msg "Access pillars and generate a lowstate listing"
sudo ssh $SSH_OPTS -i ${SALT_CLOUD_KEY_PATH} ec2-user@${MASTER} 'sudo salt \* pillar.items'
sudo ssh $SSH_OPTS -i ${SALT_CLOUD_KEY_PATH} ec2-user@${MASTER} 'sudo salt \* state.show_lowstate'
msg "Listing cached pillars - should see pillar files listed:"
sudo ssh $SSH_OPTS -i ${SALT_CLOUD_KEY_PATH} ec2-user@${MASTER} 'ls /var/cache/salt/master/pillar_gitfs/*'
msg "Listing cached remotes - there should be some hashes here:"
sudo ssh $SSH_OPTS -i ${SALT_CLOUD_KEY_PATH} ec2-user@${MASTER} 'ls /var/cache/salt/master/gitfs'
msg "Listing roles in the cluster"
sudo ssh $SSH_OPTS -i ${SALT_CLOUD_KEY_PATH} ec2-user@${MASTER} 'sudo salt \* grains.get roles'
msg "Provision the cluster now ... this will take a couple minutes"
sudo ssh $SSH_OPTS -i ${SALT_CLOUD_KEY_PATH} ec2-user@${MASTER} 'sudo salt \* state.highstate'
# msg "List java processes on the master"
# sudo ssh $SSH_OPTS -i ${SALT_CLOUD_KEY_PATH} ec2-user@${MASTER} 'ps -C java -o user,pid,pcpu'
# msg "List java processes on the first slave"
# sudo ssh $SSH_OPTS -i ${SALT_CLOUD_KEY_PATH} ec2-user@${SLAVE} 'ps -C java -o user,pid,pcpu'
# msg "The end"
