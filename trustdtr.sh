#!/bin/sh

set -e

DTR="${1}"

if [ "${DTR}" = "--help" ]
then
  echo "Usage: ${0} <dtr-fqdn>"
  exit 1
fi

if [ ! -d "/etc/docker" ]
then
  echo "Error: '/etc/docker' not found. (Did you remember to use a volume?)"
  exit 1
fi

if [ ! -d "/etc/docker/certs.d/${DTR}" ]
then
  echo -n "Creating the dirctory '/etc/docker/certs.d/${DTR}'..."
  mkdir -p /etc/docker/certs.d/${DTR}
  echo "done"
fi

echo -n "Adding self-signed server certificate to '/etc/docker/certs.d/${DTR}/ca.crt'..."
openssl s_client -host ${DTR} -port 443 </dev/null 2>/dev/null | openssl x509 -outform PEM > /etc/docker/certs.d/${DTR}/ca.crt
echo "done"
