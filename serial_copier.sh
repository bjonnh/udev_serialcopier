#!/bin/sh
ROOT="/somewhere/serial_copier"
MOUNT_PLACE="$ROOT/mnt/$2"
FILE_PLACE="$ROOT/content"
DEBUG_PLACE="$ROOT"
DEBUG_FILE="$ROOT/debug.txt"

if [ ! -d $MOUNT_PLACE ] ; then
	mkdir -p $MOUNT_PLACE
fi
if [ ! -d $FILE_PLACE ] ; then 
        mkdir -p $FILE_PLACE
fi
if [ ! -d $DEBUG_PLACE ] ; then 
        mkdir -p $DEBUG_PLACE
fi

echo "* Inserted $1 $2" >> $DEBUG_FILE
echo -ne " - Mounting" >> $DEBUG_FILE

mount -o sync /dev/$1 $MOUNT_PLACE

if [ $? -ne 0 ] ; then
	echo "   - Error mounting, exiting" >> $DEBUG_FILE
	exit 32
fi
echo " DONE" >> $DEBUG_FILE

echo -ne " - Copying data" >> $DEBUG_FILE
rsync -ravh $FILE_PLACE/ $MOUNT_PLACE/

if [ $? -ne 0 ] ; then
        echo "   - Error copying, not exiting, lets umount properly" >> $DEBUG_FILE
        exit 32
fi
echo " DONE" >> $DEBUG_FILE
echo -ne " - Unmounting" >> $DEBUG_FILE

umount /dev/$1
if [ $? -ne 0 ] ; then
	echo "   - Error unmounting, exiting" >> $DEBUG_FILE
	exit 32
fi
echo " DONE" >> $DEBUG_FILE
