#Bungeecord: Getting Update form your selected version.
cd $LPATH/mcsys/jar || exit 1
rm -f version.json
wget -q https://ci.md-5.net/job/BungeeCord/lastSuccessfulBuild/artifact/bootstrap/target/BungeeCord.jar
unzip -qq -t BungeeCord.jar
if [ "$?" -ne 0 ]; then
 echo "Downloaded BungeeCord.jar is corrupt. No update." | /usr/bin/logger -t $MCNAME
else
 diff -q BungeeCord.jar $LPATH/$MCNAME.jar >/dev/null 2>&1
 if [ "$?" -eq 1 ]; then
  cp BungeeCord.jar BungeeCord.jar."$(date +%Y.%m.%d.%H.%M.%S)"
  mv BungeeCord.jar $LPATH/$MCNAME.jar
  /usr/bin/find $LPATH/mcsys/jar/* -type f -mtime +10 -delete 2>&1 | /usr/bin/logger -t $MCNAME
  echo "BungeeCord.jar has been updated" | /usr/bin/logger -t $MCNAME
 else
  echo "No BungeeCord.jar update neccessary" | /usr/bin/logger -t $MCNAME
  rm BungeeCord.jar
  rm -f version.json
 fi
fi
