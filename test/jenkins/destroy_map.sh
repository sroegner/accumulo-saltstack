N=${BUILD_EXECUTOR:-1}
cd $(dirname $0)
WS=$(pwd)
SALT_CLOUD=${SALT_CLOUD_PATH:-/home/jenkins/virtual/bin/salt-cloud}
SALT_CLOUD_OPTS="--profiles=${WS}/jenkins.profiles --map=${WS}/jenkins.map"

sudo ${SALT_CLOUD} ${SALT_CLOUD_OPTS} -d -y
