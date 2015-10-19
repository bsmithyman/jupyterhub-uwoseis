
FROM bsmithyman/jupyterhub-simpeg:latest
MAINTAINER Brendan Smithyman <brendan@bitsmithy.net>

RUN apt-get -y install libx11-dev

ADD ssl/orion.pem /etc/ssl/certs/orion_es_uwo_ca.pem
ADD scripts/* /usr/local/bin/

CMD ["/srv/jupyterhub/startup.sh"]
