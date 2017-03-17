mbentley/trustdtr
=================

docker image to pull a self-signed registry certificate locally so the Docker Engine trusts it.
based off of alpine:latest

To pull this image:
`docker pull mbentley/trustdtr:latest`

Example usage:

```
docker run -it --rm \
  -v /etc/docker:/etc/docker \
  mbentley/trustdtr dtr.example.com
```

Note: You must share at least `/etc/docker/certs.d` as a volume in order to be able to write the self-signed certificate to disk.  If you're on Docker for Mac, you must use '/etc/docker`

There is one option parameter that can be set via environment variable: `ROOT_CERT`
 * `true` (default) - instructs trustdtr to get the root CA certificate as provided from DTR
 * `false` - instructs trustdtr to get the server certificate instead of the root CA certificate; useful for if the `/ca` endpoint isn't available


Example usage:

```
docker run -it --rm \
  -v /etc/docker/certs.d:/etc/docker/certs.d \
  -e ROOT_CERT=false \
  mbentley/trustdtr dtr.example.com
```
