#!/bin/bash
# GET THE RIGHT COMMAND: ./manage.tool.%server_name%
# shellcheck source=/dev/null
. ./mcsys/configs/variables.sh
mv manage.tool manage.tool.$MCNAME && sed -i '0,/%server_name%/s//$MCNAME/' ./manage.tool.* >/dev/null 2>&1
# Selector to have a nice overview about the commands.
echo -e "$MANAGET1"
{
echo -n "";
read MUPSTAT;
}
if
 if [[ $MUPSTAT == "1" ]]; then /bin/bash $MTPATH/mcsys/start.sh && exit 0
 fi
 if [[ $MUPSTAT == "2" ]]; then /bin/bash $MTPATH/mcsys/stop.sh && exit 0
 fi
 if [[ $MUPSTAT == "3" ]]; then /bin/bash $MTPATH/mcsys/restart.sh && exit 0
 fi
 if [[ $MUPSTAT == "4" ]]; then joe $MTPATH/mcsys/configs/mcsys.config && exit 0
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
