
# 4. Installing the Target Image

# All of the cross compilation is complete. Now you have everything you need to install the entire cross-compiled operating system to either a physical or virtual drive, but before doing that, let's not tamper with the original target build directory by making a copy of it: 


cp -rf ${LJOS}/ ${LJOS}-copy

rm -rfv ${LJOS}-copy/cross-tools
rm -rfv ${LJOS}-copy/usr/src/*

# Followed by the now unneeded statically compiled library files (if any): 

FILES="$(ls ${LJOS}-copy/usr/lib64/*.a)"
for file in $FILES; do
rm -f $file
done


# Now strip all debug symbols from the installed binaries. This will reduce overall file sizes and keep the target image's overall footprint to a minimum:


find ${LJOS}-copy/{,usr/}{bin,lib,sbin} -type f -exec sudo strip --strip-debug '{}' ';'

find ${LJOS}-copy/{,usr/}lib64 -type f -exec sudo strip --strip-debug '{}' ';'


# Finally, change file ownerships and create the following nodes: 


sudo chown -R root:root ${LJOS}-copy
sudo chgrp 13 ${LJOS}-copy/var/run/utmp ${LJOS}-copy/var/log/lastlog
sudo mknod -m 0666 ${LJOS}-copy/dev/null c 1 3
sudo mknod -m 0600 ${LJOS}-copy/dev/console c 5 1
sudo chmod 4755 ${LJOS}-copy/bin/busybox



# Change into the target copy directory to create a tarball of the entire operating system image:

cd ${LJOS}-copy/

sudo tar cfJ ../LJOS-build.tar.xz *


# Notice how the target image is less than 60MB. You built that—a minimal Linux operating system that occupies less than 60MB of disk space:

sudo du -h|tail -n1


# And, that same operating system compresses to less than 20MB:

# ls -lh ../LJOS-build*
#####################




