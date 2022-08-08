#!/bin/bash
# Please execute that with ./manage.tool.%server_name%

echo -e "What do you like to do?"
echo -e " 1 = Start\n 2 = Stop\n 3 = Restart\n 4 = Edit Configuration"
{
echo -n "";
read MUPSTAT;
}
MTPATH=
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
else
echo "Please type in a Number!"
exit 1
fi
