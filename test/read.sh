#!/bin/bash
echo -e "Hallo"
{
echo -n -e "-> "
read -r;
echo -e "Du hast ${REPLY} gesagt"
}
echo -e "Ich finde ${REPLY} toll"
