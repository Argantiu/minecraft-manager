#Spigot / Bukkit: Getting Update form your selected version.
if [ $ASOFTWARE = "SPIGOT" ] || [ $ASOFTWARE = "BUKKIT" ]; then
 mkdir -p $LPATH/mcsys/build
 mkdir -p $LPATH/mcsys/spitool
 cd $LPATH/mcsys/build || exit 1
 wget -q https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar -O BuildTools.jar
 unzip -qq -t BuildTools.jar
 if [ "$?" -ne 0 ]; then
  echo "Downloaded BuildTools.jar is corrupt. No update." | /usr/bin/logger -t $MCNAME
 else
  if [ -f $LPATH/mcsys/spitool/BuildTools.jar ]; then
   echo "BuildTools exists" | /usr/bin/logger -t $MCNAME
  else
   touch $LPATH/mcsys/spitool/BuildTools.jar
  fi
  diff $LPATH/mcsys/build/BuildTools.jar $LPATH/mcsys/spitool/BuildTools.jar >/dev/null 2>&1
  if [ "$?" -eq 1 ]; then
   cp $LPATH/mcsys/build/BuildTools.jar $LPATH/mcsys/spitool/BuildTools.jar
   cd $LPATH/mcsys/spitool/ || exit 1
   cp BuildTools.jar BuildTools.jar"$(date +%Y.%m.%d.%H.%M.%S)"
   cd $LPATH/mcsys/build || exit 1
   if [ $ASOFTWARE = "SPIGOT" ]; then
    java -jar BuildTools.jar --rev $MAINVERSION #--output-dir $LPATH/mcsys/build/
    cp $LPATH/mcsys/build/spigot-$MAINVERSION.jar $LPATH/mcsys/spitool/spigot-$MAINVERSION.jar"$(date +%Y.%m.%d.%H.%M.%S)"
    mv $LPATH/mcsys/build/spigot-$MAINVERSION.jar $LPATH/$MCNAME.jar
   fi
   if [ $ASOFTWARE = "BUKKIT" ]; then
    java -jar BuildTools.jar --rev $MAINVERSION --compile craftbukkit 
    cp $LPATH/mcsys/build/craftbukkit-$MAINVERSION.jar $LPATH/mcsys/spitool/craftbukkit-$MAINVERSION.jar"$(date +%Y.%m.%d.%H.%M.%S)"
    mv $LPATH/mcsys/build/craftbukkit-$MAINVERSION.jar $LPATH/$MCNAME.jar
   fi
   rm -r $LPATH/mcsys/build/BuildTools
   /usr/bin/find $LPATH/mcsys/build/* -type f -mtime +10 -delete 2>&1 | /usr/bin/logger -t $MCNAME
   /usr/bin/find $LPATH/mcsys/spitool/* -type f -mtime +10 -delete 2>&1 | /usr/bin/logger -t $MCNAME»
   echo "spigot/bukkit-$MAINVERSION.jar has been updated" | /usr/bin/logger -t $MCNAME
  else
   echo "No BuildTools.jar update neccessary" | /usr/bin/logger -t $MCNAME
   rm BuildTools.jar
  fi
 fi
fi
