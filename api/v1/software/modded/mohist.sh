#!/bin/bash
#Mohist: Getting Update form your selected version.
if [ $MAINVERSION = "1.16.5" ] || [ $MAINVERSION = "1.12.2" ]; then
 mkdir -p $LPATH/mcsys/jar
 cd $LPATH/mcsys/jar || exit 1
 DATE=$(date +%Y.%m.%d.%H.%M.%S)
 wget -q https://mohistmc.com/api/$MAINVERSION/latest/download -O mohist-$MAINVERSION-$DATE.jar
 unzip -qq -t  mohist-$MAINVERSION-$DATE.jar
 if [ "$?" -ne 0 ]; then
  echo "Downloaded mohist-$MAINVERSION-$DATE.jar is corrupt. No update." | /usr/bin/logger -t $MCNAME
 else
  diff -q mohist-$MAINVERSION-$DATE.jar $LPATH/$MCNAME.jar >/dev/null 2>&1
  if [ "$?" -eq 1 ]; then
   cp mohist-$MAINVERSION-$DATE.jar  mohist-$MAINVERSION-$DATE.jar.backup
   mv mohist-$MAINVERSION-$DATE.jar $LPATH/$MCNAME.jar
   /usr/bin/find $LPATH/mcsys/jar/* -type f -mtime +10 -delete 2>&1 | /usr/bin/logger -t $MCNAME
   echo "mohist-$MAINVERSION-$DATE.jar has been updated" | /usr/bin/logger -t $MCNAME
  else
   echo "No mohist-$MAINVERSION-$DATE.jar update neccessary" | /usr/bin/logger -t $MCNAME
   rm mohist-$MAINVERSION-$DATE.jar
  fi
 fi
else
echo "Mohist have no Complete support for this Minecraft Version."
echo "Please use Crucible for 1.7.10 or Arclight for 1.18.2"
fi
