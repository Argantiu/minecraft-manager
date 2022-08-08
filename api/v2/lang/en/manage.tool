#!/bin/bash
# Please execute that with ./manage.tool
echo -e "What do you like to do?"
echo -e " 1 = Start\n 2 = Stop\n 3 = Restart\n 4 = Edit Configuration"
{
echo -n "";
read MUPSTAT;
}
if 
if [[ $MUPSTAT == "1" ]]; then
 /bin/bash $LPATH/mcsys/start.sh
 exit 0
fi
if [[ $MUPSTAT == "2" ]]; then
 /bin/bash $LPATH/mcsys/stop.sh
 exit 0
fi
if [[ $MUPSTAT == "3" ]]; then
 /bin/bash $LPATH/mcsys/restart.sh
 exit 0
fi
if [[ $MUPSTAT == "4" ]]; then
 joe $LPATH/mcsys/configs/mcsys.config
fi
else
echo "Please type in a Number!"
exit 1
