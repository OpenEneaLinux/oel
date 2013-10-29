find . -name layer.conf | xargs -i realpath {}  | grep -v poky | sed -e 's:conf/layer.conf: \:g'
