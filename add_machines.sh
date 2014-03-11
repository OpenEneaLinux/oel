#!/bin/bash
#
# $1 should be repo base directory
# $2 shoule be BBSERVER=localhost:8200 if a BBSERVER is used

machines=$(find $1/meta* -regextype posix-extended -regex '.*machine/.*\.conf' | xargs -i realpath {} | grep -v scripts | sed -e 's/.*\(machine\/.*\)\.conf/\1/g' | sed -e 's:machine/::g')
echo  "#!/bin/bash" > buildall.sh

for machine in $machines; do
    echo "$2 PACKAGE_CLASSES=\"package_ipk\" MACHINE=\"$machine\" bitbake core-image-minimal-ipk" >> buildall.sh
    echo "$2 PACKAGE_CLASSES=\"package_rpm\" MACHINE=\"$machine\" bitbake core-image-minimal-rpm" >> buildall.sh
    echo "$2 SDKMACHINE=\"x86_64\" MACHINE=\"$machine\" bitbake -c populate_sdk core-image-minimal" >> buildall.sh
    echo "$2 MACHINE=\"$machine\" bitbake virtual/bootloader" >> buildall.sh
    echo "$2 SDKMACHINE=\"x86_64\" MACHINE=\"$machine\" bitbake package-index" >> buildall.sh
    echo "$2 SDKMACHINE=\"i686\" MACHINE=\"$machine\" bitbake -c populate_sdk core-image-minimal" >> buildall.sh
    echo "$2 SDKMACHINE=\"i686\" MACHINE=\"$machine\" bitbake package-index" >> buildall.sh
    echo "$2 MACHINE=\"$machine\" bitbake -k world" >> buildall.sh
    echo "$2 MACHINE=\"$machine\" bitbake package-index" >> buildall.sh
    echo "" >> buildall.sh

    echo  "#!/bin/bash" > build_$machine.sh
    echo "$2 PACKAGE_CLASSES=\"package_ipk\" MACHINE=\"$machine\" bitbake core-image-minimal-ipk" >> build_$machine.sh
    echo "$2 PACKAGE_CLASSES=\"package_rpm\" MACHINE=\"$machine\" bitbake core-image-minimal-rpm" >> build_$machine.sh
    echo "$2 SDKMACHINE=\"x86_64\" MACHINE=\"$machine\" bitbake -c populate_sdk core-image-minimal" >> build_$machine.sh
    echo "$2 MACHINE=\"$machine\" bitbake virtual/bootloader" >> build_$machine.sh
    echo "$2 SDKMACHINE=\"x86_64\" MACHINE=\"$machine\" bitbake package-index" >> build_$machine.sh
    echo "$2 SDKMACHINE=\"i686\" MACHINE=\"$machine\" bitbake -c populate_sdk core-image-minimal" >> build_$machine.sh
    echo "$2 SDKMACHINE=\"i686\" MACHINE=\"$machine\" bitbake package-index" >> build_$machine.sh
    echo "$2 MACHINE=\"$machine\" bitbake -k world" >> build_$machine.sh
    echo "$2 MACHINE=\"$machine\" bitbake package-index" >> build_$machine.sh
    chmod 755 build_$machine.sh
done
chmod 755 buildall.sh