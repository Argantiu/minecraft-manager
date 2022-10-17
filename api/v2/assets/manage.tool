#!/bin/bash
# Bitte diese datei mit ./manage.tool.%server_name% ausfueren.
. ./mcsys/configs/variables.sh
mv manage.tool manage.tool.$MCNAME
sed -i 's;%server_name%;$MCNAME;g' ./manage.tool.* >/dev/null 2>&1

echo -e "Was möchtest du den machen?\n 1 = Starten\n 2 = Stoppen\n 3 = Neustarten\n 4 = Konfiguration Bearbeiten\n 5 = System Endfernen"
{
echo -n "";
read MUPSTAT;
}
MTPATH=$(cat ./mcsys/configs/mcsys.config | grep complete.path | cut -d ':' -f2)
if
 if [[ $MUPSTAT == "1" ]]; then
  /bin/bash $MTPATH/mcsys/start.sh
  exit 0
 fi
 if [[ $MUPSTAT == "2" ]]; then
  /bin/bash $MTPATH/mcsys/stop.sh
  exit 0
 fi
 if [[ $MUPSTAT == "3" ]]; then
  /bin/bash $MTPATH/mcsys/restart.sh
  exit 0
 fi
 if [[ $MUPSTAT == "4" ]]; then
  joe $MTPATH/mcsys/configs/mcsys.config
  exit 0
 fi
 if [[ $MUPSTAT == "5" ]]; then
  echo -e "Möchtest du wirklich das System endfernen? (Dein Server bleibt erhalten)\n Ja oder ja um die löschung zu bestätigen.\nAlles andere zählt als Nein."
  {
  echo -n "";
  read MCONFIRM;
  }
  if [[ $MCONFIRM == "Ja" ]] || [[ $MCONFIRM == "ja" ]]; then
  /bin/bash $MTPATH/mcsys/stop.sh
  rm -r ./mcsys
  echo -e "Oh wie schade dass du uns nicht mehr haben möchtest. Bitte endferne auch das 'manage.tool.%server_name%' denn ich kann mich nicht selber löschen :("
  sed -i 's;#!/bin/bash;#!/disabled;g' ./manage.tool.%server_name% >/dev/null 2>&1
  exit 0
  else
  echo -e "Oh ein glück das du das nicht so mit uns meintest."
  exit 0
 fi
 else
 echo "Bitte gebe eine Nummer an!"
 exit 1
fi