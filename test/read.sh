#!/bin/bash
echo -e "Hallo"
{
echo -n -e "-> "
read;
echo -e "Du hast ${REPLY} gesagt"
}
echo -e "Ich finde ${REPLY} toll"
