#!/bin/bash
#
# $1 should be repo base directory
# $2 shoule be BBSERVER=localhost:8200 if a BBSERVER is used

machines=$(find $1/meta* -regextype posix-extended -regex '.*machine/.*\.conf' | xargs -i realpath {} | grep -v scripts | sed -e 's/.*\(machine\/.*\)\.conf/\1/g' | sed -e 's:machine/::g')
machines+=$(find $1/meta* -regextype posix-extended -regex '.*conf/machine/.*\.conf' | xargs -i realpath {} | grep -v scripts | sed -e 's/.*\(machine\/.*\)\.conf/\1/g' | sed -e 's:machine/::g')
machines+=$(find $1/poky* -regextype posix-extended -regex '.*conf/machine/.*\.conf' | xargs -i realpath {} | grep -v scripts | sed -e 's/.*\(machine\/.*\)\.conf/\1/g' | sed -e 's:machine/::g')

echo  "#!/bin/bash" > buildall.sh
echo "" >> buildall.sh

for machine in $machines; do
    echo "./build_$machine.sh &> buildlog_$machine.txt" >> buildall.sh

    echo  "#!/bin/bash" > build_$machine.sh
    echo "$2 PACKAGE_CLASSES=\"package_ipk\" MACHINE=\"$machine\" bitbake -k core-image-minimal-ipk" >> build_$machine.sh
    echo "$2 PACKAGE_CLASSES=\"package_rpm\" MACHINE=\"$machine\" bitbake -k core-image-minimal-rpm" >> build_$machine.sh
    echo "$2 SDKMACHINE=\"x86_64\" MACHINE=\"$machine\" bitbake -c populate_sdk -k core-image-minimal" >> build_$machine.sh
    echo "$2 MACHINE=\"$machine\" bitbake virtual/bootloader" >> build_$machine.sh
    echo "$2 SDKMACHINE=\"x86_64\" MACHINE=\"$machine\" bitbake package-index" >> build_$machine.sh
    echo "$2 SDKMACHINE=\"i686\" MACHINE=\"$machine\" bitbake -c populate_sdk -k core-image-minimal" >> build_$machine.sh
    echo "$2 SDKMACHINE=\"i686\" MACHINE=\"$machine\" bitbake package-index" >> build_$machine.sh
    echo "$2 MACHINE=\"$machine\" bitbake -k world" >> build_$machine.sh
    echo "$2 MACHINE=\"$machine\" bitbake package-index" >> build_$machine.sh
    chmod 755 build_$machine.sh
done
echo "" >> buildall.sh

chmod 755 buildall.sh
