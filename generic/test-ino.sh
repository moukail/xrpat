#!/bin/sh

ARDUINOMODEL=ethernet

cd $HOME && mkdir -p dev && cd dev && mkdir -p arduino && cd arduino && mkdir -p blink && cd blink && ino init -t blink && ino build -m $ARDUINOMODEL && ino upload -m $ARDUINOMODEL

exit 0
