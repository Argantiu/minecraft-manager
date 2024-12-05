#!/bin/bash
source cycodly/VariableReader

function Start() {
    
}

function Stop() {
    
}

function Restart() {
    
}

function Remove() {
    
}

function Help() {
    
}

case "$1" in
    1|'start') Start;;
    2|'stop') Stop;;
    3|'restart') Restart;;
    4|'remove') Remove;;
    *) Help;;
esac