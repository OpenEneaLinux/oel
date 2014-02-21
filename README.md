Open Enea Linux
===

Building OEL
--

mkdir -p ~/bin/

wget https://raw.github.com/OpenEneaLinux/oel/master/repo -O ~/bin/repo;

chmod 755 ~/bin/repo;

mkdir oel; cd oel;

repo init -u https://github.com/OpenEneaLinux/oel.git;

repo sync;

source poky/oe-init-build-env build

# Manually add layers or automatically add layers with https://github.com/OpenEneaLinux/oel/blob/master/add_layers.sh

../.repo/manifests/add_layers.sh ../

Change DISTRO="oel" in conf/local.conf

bitbake core-image-lsb 

bitbake -k world

bitbake -c populate_sdk core-image-lsb
