mbentley/trustdtr
=================

docker image to pull a self-signed registry certificate locally so the Docker Engine trusts it.
based off of alpine:latest

To pull this image:
`docker pull mbentley/trustdtr:latest`

Example usage:

`docker run -it --rm -v /etc/docker/certs.d:/etc/docker/certs.d mbentley/trustdtr dtr.example.com`

Note: You must share at least `/etc/docker/certs.d` as a volume in order to be able to write the self-signed certificate to disk.
