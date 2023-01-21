#!/bin/bash

MCVERSION=$(yq eval '.version' mcsys.yml && cut -d "." -f2)
if [[ $MCVERSION == "19" ]] || [[ $MCVERSION == "18" ]]; then

else 
fi
