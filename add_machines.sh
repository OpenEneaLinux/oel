#!/bin/bash
#
# $1 should be repo base directory
# $2 shoule be BBSERVER=localhost:8200 if a BBSERVER is used

machines=$(find $1 -regextype posix-extended -regex '.*machine/.*\.conf' | xargs -i realpath {} | grep -v scripts | sed -e 's/.*\(machine\/.*\)\.conf/\1/g' | sed -e 's:machine/::g')
echo  "#!/bin/bash" > buildall.sh

for machine in $machines; do
    echo "$2 MACHINE=\"$machine\" bitbake core-image-minimal" >> buildall.sh
    echo "$2 SDKMACHINE=\"x86_64\" MACHINE=\"$machine\" bitbake -c populate_sdk core-image-minimal" >> buildall.sh
    echo "$2 SDKMACHINE=\"i686\" MACHINE=\"$machine\" bitbake -c populate_sdk core-image-minimal" >> buildall.sh
    echo "$2 MACHINE=\"$machine\" bitbake -k world" >> buildall.sh
done
