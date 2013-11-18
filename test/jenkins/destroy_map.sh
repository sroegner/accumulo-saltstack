N=${BUILD_EXECUTOR:-1}
cd $(dirname $0)
WORKSPACE=$(pwd)
SALT_CLOUD=${SALT_CLOUD_PATH:-/home/jenkins/virtual/bin/salt-cloud}
SALT_CLOUD_OPTS="--profiles=${WORKSPACE}/jenkins.profiles --map=${WORKSPACE}/jenkins.map"

sudo ${SALT_CLOUD} ${SALT_CLOUD_OPTS} -d -y

