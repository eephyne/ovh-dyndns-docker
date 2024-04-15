# DynDNS update script for OVH domains

![Build image](https://github.com/eephyne/ovh-dyndns-docker/workflows/Build%20ovh-dyndns%20image/badge.svg)
[![Build Status](https://travis-ci.com/eephyne/ovh-dyndns-docker.svg?branch=master)](https://travis-ci.com/ephyne/ovh-dyndns-docker)

this is based on _ovh-dyndns_ from [Ambroisemaupate work](https://github.com/ambroisemaupate/Docker) and forked from webhainaut repository to add multiple domain update

https://docs.ovh.com/fr/domains/utilisation-dynhost/

Check every 5 minutes you WAN IP and if changed call OVH entry-point to update
your DynDNS domains.

you can set as many $HOSTX as you want, starting from 1 and incrementing
if you need separate login and password, you can set LOGINX and PASSWORDX to match the host, if no LOGINX is fount it fallback to LOGIN and PASSWORD

```
docker run -d --name="ovh-dyndns" \
    -e "HOST1=mydynamicdomain.domain.com" \
    -e "LOGIN=mylogin" \
    -e "PASSWORD=mypassword" \
    ambroisemaupate/ovh-dyndns
```

## Docker-compose

```
version: "3"
services:
  crond:
    image: ambroisemaupate/ovh-dyndns
    environment:
      HOST1: mydynamicdomain.domain.com
      LOGIN: mylogin
      PASSWORD: mypassword
      HOST2: mydynamicdomain2.domain.com
      LOGIN2: mysecondlogin
      PASSWORD2: mysecondpassword
      HOST3: mydynamicdomain2.domain.com

    restart: always
```

## Customize external NS server

By default, we use Google DNS to check your current DynDNS IP, but you can choose an
other DNS overriding `NSSERVER` env var:

```
docker run -d --name="ovh-dyndns" \
    -e "HOST1=mydynamicdomain.domain.com" \
    -e "LOGIN=mylogin" \
    -e "PASSWORD=mypassword" \
    -e "NSSERVER=192.168.1.1" \
    ambroisemaupate/ovh-dyndns
```
