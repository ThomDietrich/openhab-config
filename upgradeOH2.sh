#!/usr/bin/env bash

INSTALL_DIR="/opt/openhab2"

echo "This will replace openHAB2 runtime files."
read -p "Are you sure openHAB2 is not running? [y/N] " input
if [ "$input" != "y" ]
then
    exit 1
fi

rm openhab-offline-2.0.0-SNAPSHOT.zip
wget https://openhab.ci.cloudbees.com/job/openHAB-Distribution/lastSuccessfulBuild/artifact/distributions/openhab-offline/target/openhab-offline-2.0.0-SNAPSHOT.zip

DATE=`date +%Y%m%H%M`
cp -apv $INSTALL_DIR $INSTALL_DIR.$DATE
echo "for a clean start:"
read -p "Clean start? [y/N] " input
if [ "$input" == "y" ]
then
    rm -rf $INSTALL_DIR/addons $INSTALL_DIR/runtime $INSTALL_DIR/userdata $INSTALL_DIR/LICENSE.TXT $INSTALL_DIR/start.* $INSTALL_DIR/start_debug.*
    ls -laF $INSTALL_DIR
    read -p "only conf folder should be left now? [Enter] "
fi
unzip -o openhab-offline-2.0.0-SNAPSHOT.zip -d $INSTALL_DIR/
rm openhab-offline-2.0.0-SNAPSHOT.zip

chown pi:openhab $INSTALL_DIR
sed -e "s/sshHost = 127.0.0.1/sshHost = 0.0.0.0/g" $INSTALL_DIR/runtime/karaf/etc/org.apache.karaf.shell.cfg

echo "newest openHAB2 build extracted."
echo "execute: 'screen -d -m /opt/openhab2/start.sh'"
