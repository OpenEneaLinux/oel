Open Enea Linux
===

This is the Setup layer for Open Enea Linux.

Maintenance
-----------

Send pull requests, patches, comments or questions to openenealinux@lists.openenealinux.org
Please note that this list should only be used for patches for meta-oel, and the oel git
repositories.
Bugfixes and additions for other layers should be sent to respective layers mailinglist,
usually denoted in the README file in that specific layer.


Maintainers: David Nyström <david.c.nystrom@gmail.com>
	     Jon Aldama <jon.aldama@enea.com>

When sending single patches, please using something like:
'git send-email -1 --to openenealinux@lists.openenealinux.org --subject-prefix=oel][PATCH'

License
-------

All metadata is MIT licensed unless otherwise stated. Source code included
in tree for individual recipes is under the LICENSE stated in each recipe
(.bb file) unless otherwise stated.


Building OEL
-------

mkdir -p ~/bin/

wget https://raw.github.com/OpenEneaLinux/oel/master/repo -O ~/bin/repo;

chmod 755 ~/bin/repo;

mkdir oel; cd oel;

repo init -u https://github.com/OpenEneaLinux/oel.git;

repo sync;

TEMPLATECONF="$(realpath meta-oel/conf)" source poky/oe-init-build-env build

../.repo/manifests/add_layers.sh ../

../.repo/manifests/add_machines.sh ../

... Use per-MACHINE scripts to build the entire release, i.e. ...

./build_beaglebone.sh

... Or use bitbake normally ...

bitbake core-image-minimal

bitbake -k world

bitbake -c populate_sdk core-image-lsb
