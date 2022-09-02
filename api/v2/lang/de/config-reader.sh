#!/bin/bash
# Read all settings to get a computer output
#cat mcsys.config | grep [pattern] | awk '{ print $number-of-column }' >> file1
cat mcsys.config | grep MAINVERSION= | sed -i "0,/MAINVERSION=.*/s//MAINVERSION=$MAINVERSION/" $LPATH/mcsys/start.sh >/dev/null 2>&1
