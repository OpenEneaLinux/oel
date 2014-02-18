Open Enea Linux
===

Building OEL
--

wget https://github.com/OpenEneaLinux/oel/blob/master/repo ~/bin/repo;

chmod 755 ~/bin/repo;

mkdir oel; cd oel;

repo init -u https://github.com/OpenEneaLinux/oel.git;

repo sync;

source poky/oe-init<TAB> build;

Manually add layers or automatically add layers with https://github.com/OpenEneaLinux/oel/blob/master/add_layers.sh

Change DISTRO="oel"

bitbake core-image-lsb world

bitbake -c populate_sdk core-image-lsb
