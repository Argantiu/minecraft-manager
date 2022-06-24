#!/bin/bash
# Bitte diese datei mit ./manage.tool ausfueren.
echo -e "Was möchtest du den machen?"
echo -e " 1 = Starten\n 2 = Stoppen\n 3 = Neustarten\n 4 = Konfiguration Bearbeiten"
{
echo -n "";
read MUPSTAT;
}
if [[ $MUPSTAT == "1" ]]; then
 /bin/bash $LPATH/mcsys/configs/mcsys.config
 /bin/bash $LPATH/mcsys/start.sh
 exit 0
fi
if [[ $MUPSTAT == "2" ]]; then
 /bin/bash $LPATH/mcsys/configs/mcsys.config
 /bin/bash $LPATH/mcsys/stop.sh
 exit 0
fi
if [[ $MUPSTAT == "3" ]]; then
 /bin/bash $LPATH/mcsys/configs/mcsys.config
 /bin/bash $LPATH/mcsys/restart.sh
 exit 0
fi
if [[ $MUPSTAT == "4" ]]; then
 joe $LPATH/mcsys/configs/mcsys.config
fi
exit 1
