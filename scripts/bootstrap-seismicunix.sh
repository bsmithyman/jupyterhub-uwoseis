#!/bin/bash

export CWPROOT=$HOME/SU
export SUVERSION=44
export SURELEASE=44R0

# ------------------------------------------------------------------------
# Seismic Unix

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

cat >> $HOME/.bashrc << END

export CWPROOT=$CWPROOT
export PATH="$CWPROOT/bin:$PATH"
END
