#!/bin/sh

/lenra/devtools/rel/dev_tools/bin/dev_tools start &
if [ "$1" != "" ]
then
    eval $@
fi 