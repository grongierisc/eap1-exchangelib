#!/bin/bash

STARTDIR=`pwd`

iris session iris << __DONE
do \$system.OBJ.ImportDir("$STARTDIR/src","*.cls","ck",,1)
halt
__DONE
