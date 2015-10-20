#!/bin/bash

export GITROOT=https://orion.es.uwo.ca/git/uwoseismicimaging
export HOSTCERT=/etc/ssl/certs/orion_es_uwo_ca.pem

export GPDEFAULT=$HOME/pratt
export MAKELIBS="apgen dbssgy dbstrc fileio string useful"

# ------------------------------------------------------------------------
# UWO FWI codes

read -p "Install path? [$GPDEFAULT]: " GP
export GP=${GP:-$GPDEFAULT}

echo
echo "Installing to $GP..."
echo

export FULLWV_ROOT=$GP

mkdir -p $GP/lib
mkdir -p $GP/bin

cd $GP/lib
echo
echo "Installing LIBRARIES..."
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
echo
echo "Installing FULLWV..."
GIT_SSL_CAINFO=$HOSTCERT git clone $GITROOT/fullwv.git fullwv
cd fullwv
git config http.sslCAInfo $HOSTCERT
make

cd $GP
echo
echo "Installing WORKSGY..."
GIT_SSL_CAINFO=$HOSTCERT git clone $GITROOT/worksgy.git worksgy
cd worksgy
git config http.sslCAInfo $HOSTCERT
make

# ------------------------------------------------------------------------
# System Environment

read -p "Modify .bashrc? [Y]: " MODIFY
export MODIFY=${MODIFY:-Y}

case "$MODIFY" in
    Y*|y*) cat >> $HOME/.bashrc << END

export GP=$GP
export FULLWV_ROOT=$FULLWV_ROOT
export PATH="$GP/bin:$PATH"
END
;;
esac

