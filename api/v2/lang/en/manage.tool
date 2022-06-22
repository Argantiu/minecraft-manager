#!/bin/bash
# Please execute that with ./manage.tool
echo -e "What do you like to do?"
echo -e " 1 = Start\n 2 = Stop\n 3 = Restart"
{
echo -n "";
read MUPSTAT;
}
if [[ $MUPSTAT = "1" ]]; then
