EC2 Example
===========

Go to the example directory and run the following commands:

(Tested on Ubuntu 12.04/13.04)

```
sudo apt-get install python-m2crypto build-essential zlib1g-dev
virtualenv --system-site-packages ~/accumulo-saltstack-env
. ~/accumulo-saltstack-env/bin/activate
pip install apache-libcloud
pip install mako
pip install salt
pip install -e git+https://github.com/vhgroup/salt-cloud.git@v0.8.9-stable#egg=salt-cloud 
mkdir cloud.keys
cp your-ssh-key cloud.keys/accumulo-saltstack.pem
chmod 600 cloud.keys/accumulo-saltstack.pem
salt-cloud -C cloud -m cloud.map \
  --providers-config=cloud.providers.d/amazon-ec2-us-east.yaml \
  --profiles=cloud.profiles.d/amazon.yaml
```

Status
------

States apply clean. Accumulo wasn't tested yet.
