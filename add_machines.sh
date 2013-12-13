#!/bin/bash
#
# $1 should be repo base directory
#

machines=$(find $1 -regextype posix-extended -regex '.*machine/.*\.conf' | xargs -i realpath {} | grep -v scripts | sed -e 's/.*\(machine\/.*\)\.conf/\1/g' | sed -e 's:machine/::g')
echo  "#!/bin/bash" > buildall.sh

for machine in $machines; do
    echo "MACHINE=\"$machine\" bitbake core-image-minimal" >> buildall.sh
    echo "SDKMACHINE=\"x86_64\" MACHINE=\"$machine\" bitbake -c populate_sdk core-image-minimal" >> buildall.sh
    echo "SDKMACHINE=\"i686\" MACHINE=\"$machine\" bitbake -c populate_sdk core-image-minimal" >> buildall.sh
    echo "MACHINE=\"$machine\" bitbake -k world" >> buildall.sh
done
