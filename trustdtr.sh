#!/bin/sh

DTR="${1}"

ROOT_CERT="${ROOT_CERT:-true}"

if [ "${DTR}" = "--help" ]
then
  echo "Usage: ${0} <dtr-fqdn>"
  exit 1
fi

# check to see if /etc/docker exists in container
if [ ! -d "/etc/docker" ]
then
  echo "Error: '/etc/docker' not found. (Did you remember to use a volume?)"
  exit 1
fi

# check to see if the DTR FQDN directory exists
if [ ! -d "/etc/docker/certs.d/${DTR}" ]
then
  echo -n "Creating the dirctory '/etc/docker/certs.d/${DTR}'..."
  mkdir -p /etc/docker/certs.d/${DTR}
  echo "done"
fi

# display with trust method is being used
if [ "${ROOT_CERT}" = "true" ]
then
  echo "Using the root CA certificate for trusting DTR"
else
  echo "Using the server certificate for trusting DTR"
fi

echo -n "Adding certificate to '/etc/docker/certs.d/${DTR}/ca.crt'..."

# check to see if we should get the root or server certificate and act accordingly
if [ "${ROOT_CERT}" = "true" ]
then
  # get CA cert from DTR
  curl -ksf https://${DTR}/ca > /etc/docker/certs.d/${DTR}/ca.crt
else
  # get server certificate from DTR
  openssl s_client -host ${DTR} -port 443 </dev/null 2>/dev/null | openssl x509 -outform PEM > /etc/docker/certs.d/${DTR}/ca.crt
fi

# verify command worked to get the certificate
if [ "$?" -ne "0" ]
then
  echo "error"
  echo -e "\nFailed to get the certificate"
  exit 1
else
  echo "done"
fi

# verify certificate is an actual certificate; remove if not
echo -n "Verifying format of certificate..."
openssl x509 -in /etc/docker/certs.d/${DTR}/ca.crt -text -noout >/tmp/openssl_output 2>&1

# verify openssl verification succeeded
if [ "$?" -ne "0" ]
then
  echo -e "error\n"
  echo "Certificate validation failed:"
  cat /tmp/openssl_output
  echo -e "\nCleaning up '/etc/docker/certs.d/${DTR}'"
  rm /etc/docker/certs.d/${DTR}/ca.crt /tmp/openssl_output
  exit 1
else
  rm /tmp/openssl_output
  echo "done"
fi
