#!/bin/bash
#PurPur: Getting Update form your selected version.
 mkdir -p $LPATH/mcsys/jar
 cd $LPATH/mcsys/jar || exit 1
 rm -f version.json
 wget -q https://api.purpurmc.org/v2/purpur/$MAINVERSION -O version.json
 LATEST=$(cat < version.json | jq -r ".builds" | grep -v "," | grep -v ":" | grep -e "[0-9]" | cut -d "\"" -f2)
 wget -q https://api.purpurmc.org/v2/purpur/$MAINVERSION/$LATEST/download -O purpur-$MAINVERSION-$LATEST.jar
 unzip -qq -t purpur-$MAINVERSION-$LATEST.jar
 if [ "$?" -ne 0 ]; then
  echo "Downloaded purpur-$MAINVERSION-$LATEST.jar is corrupt. No update." | /usr/bin/logger -t $MCNAME
 else
  diff -q purpur-$MAINVERSION-$LATEST.jar $LPATH/$MCNAME.jar >/dev/null 2>&1 
  if [ "$?" -eq 1 ]; then
   cp purpur-$MAINVERSION-$LATEST.jar purpur-$MAINVERSION-$LATEST.jar."$(date +%Y.%m.%d.%H.%M.%S)"
   mv purpur-$MAINVERSION-$LATEST.jar $LPATH/$MCNAME.jar
   /usr/bin/find $LPATH/mcsys/jar/* -type f -mtime +10 -delete 2>&1 | /usr/bin/logger -t $MCNAME
   echo "purpur-$MAINVERSION-$LATEST has been updated" | /usr/bin/logger -t $MCNAME
   rm version.json
  else
   echo "No purpur-$MAINVERSION-$LATEST update neccessary" | /usr/bin/logger -t $MCNAME
   rm purpur-$MAINVERSION-$LATEST.jar
   rm version.json
  fi
 fi
fi
