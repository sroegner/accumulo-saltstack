EC2 Example
===========

Go to the example directory and run the following commands:

(Tested on Ubuntu 12.04/13.04)

```
sudo apt-get install python-m2crypto
virtualenv --system-site-packages ~/accumulo-saltstack-env
. ~/accumulo-saltstack-env/bin/activate
pip install apache-libcloud
pip install mako
pip install salt
pip install -e git+https://github.com/vhgroup/salt-cloud.git@v0.8.9-stable#egg=salt-cloud 
cp your-ssh-key accumulo-saltstack.pem
chmod 600 accumulo-saltstack.pem
salt-cloud -C cloud -m accumulo-demo.map --providers-config=cloud.providers \
  --profiles=cloud.profiles
```

Status
------

Works in the salt-cloud host. Accumulo and deps wasn't checked yet.
