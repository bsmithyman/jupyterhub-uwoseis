#!/bin/bash

export CWPROOTDEFAULT=$HOME/SU
export SUVERSION=44
export SURELEASE=44R0

# ------------------------------------------------------------------------
# Seismic Unix

read -p "Install path? [$CWPROOTDEFAULT]: " CWPROOT
export CWPROOT=${CWPROOT:-$CWPROOTDEFAULT}

echo
echo "Installing to $CWPROOT..."
echo

mkdir -p $CWPROOT
cd $CWPROOT
curl ftp://ftp.cwp.mines.edu/pub/cwpcodes/cwp_su_all_${SURELEASE}.tgz | tar -xzvf -
cd src/
touch LICENSE_${SUVERSION}_ACCEPTED
touch MAILHOME_${SUVERSION}
make install << END
y
END
make finstall
make utils

# ------------------------------------------------------------------------
# System Environment

read -p "Modify .bashrc? [Y]: " MODIFY
export MODIFY=${MODIFY:-Y}

case "$MODIFY" in
    Y*|y*) cat >> $HOME/.bashrc << END

export CWPROOT=$CWPROOT
export PATH="$CWPROOT/bin:$PATH"
END
;;
esac
