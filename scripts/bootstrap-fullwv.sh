#!/bin/bash

export GITROOT=https://orion.es.uwo.ca/git/uwoseismicimaging
export HOSTCERT=/etc/ssl/certs/orion_es_uwo_ca.pem

export GP=$HOME/pratt
export FULLWV_ROOT=$GP
export MAKELIBS="apgen dbssgy dbstrc fileio string useful"

export CWPROOT=$HOME/SU
export SUVERSION=44
export SURELEASE=44R0

# ------------------------------------------------------------------------
# UWO FWI codes

mkdir -p $GP/lib
mkdir -p $GP/bin

cd $GP/lib
GIT_SSL_CAINFO=$HOSTCERT git clone $GITROOT/lib.git gfortran
export GFDIR=$GP/lib/gfortran

cd $GFDIR
git config http.sslCAInfo $HOSTCERT

for lib in $MAKELIBS
do
  cd $GFDIR/${lib}
  make
done

cd $GP
git clone $GITROOT/fullwv.git fullwv
cd fullwv
git config http.sslCAInfo $HOSTCERT
make

cd $GP
git clone $GITROOT/worksgy.git worksgy
cd worksgy
git config http.sslCAInfo $HOSTCERT
make

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

export GP=$GP
export FULLWV_ROOT=$FULLWV_ROOT
export CWPROOT=$CWPROOT
export PATH="$GP/bin:$CWPROOT/bin:$PATH"
END
