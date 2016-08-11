#!/bin/bash

#prevent 'no such file' error if no .ssh in tmp
touch /tmp/dummy.sh
dos2unix /tmp/*.sh
