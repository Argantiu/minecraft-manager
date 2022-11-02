#!/bin/bash
# GET THE RIGHT COMMAND: ./manage.tool
# shellcheck source=/dev/null
cd ./mcsys/configs || exit 1
source variables.sh
cd $MTPATH || exit 1
# Selector to have a nice overview about the commands.
echo -e "$MANAGET1"
{
echo -n " ";
read MUPSTAT;
}
if
 if [[ $MUPSTAT == "1" ]]; then /bin/bash $MTPATH/mcsys/start.sh && exit 0
 fi
 if [[ $MUPSTAT == "2" ]]; then /bin/bash $MTPATH/mcsys/stop.sh && exit 0
 fi
 if [[ $MUPSTAT == "3" ]]; then /bin/bash $MTPATH/mcsys/restart.sh && exit 0
 fi
 if [[ $MUPSTAT == "4" ]]; then joe $MTPATH/mcsys/configs/mcsys.yml && exit 0
 fi
 if [[ $MUPSTAT == "5" ]]; then
  echo -e "$MANAGET2"
  {
  echo -n "";
  read MCONFIRM;
  }
  if [[ $MCONFIRM == "Ja" ]] || [[ $MCONFIRM == "ja" ]] || [[ $MCONFIRM == "yes" ]] || [[ $MCONFIRM == "Yes" ]]; then /bin/bash $MTPATH/mcsys/stop.sh && sleep 10s && rm -r ./mcsys && echo -e "$MANAGET3"
  rm -- "$0"
  exit 0
  else echo -e "$MANAGET4"
  exit 0
 fi
 else echo -e "$MANAGET5"
 exit 1
fi
