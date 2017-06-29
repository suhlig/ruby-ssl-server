# Spike on a Ruby SSL Server with Client Certificate Authentication

This is, as part of the Cloud Foundry [bits-service](https://github.com/cloudfoundry-incubator/bits-service), a spike on a simple Ruby web server that uses SSL certificates to authenticate clients on the TLS layer.

It is based on an [earlier article]( http://www.networkworld.com/article/2285193/infrastructure-management/creating-an-ssl-certificate-for-webrick.html) and adds:

* Certificate generation using scripts borrowed from [Cloud Foundry](https://github.com/cloudfoundry/cf-release/), which internally use [certstrap](https://github.com/square/certstrap)
* Client certificate authentication (mainly by adding the `OpenSSL::SSL::VERIFY_FAIL_IF_NO_PEER_CERT` flag, as recommended [in this article](https://stackoverflow.com/a/7735684))
* A simple test using curl

# Test

Don't run this on OSX due to its old OpenSSL library. It does work on a Linux system, e.g. using the provided Vagrant file:

1. Add `cc.service.cf.internal` as an additional alias of localhost to `/etc/hosts`
1. Start the server

  ```bash
  cd /vagrant/
  ruby ssl-server.rb
  ```

1. Run tests using curl:

  ```bash
  curl https://cc.service.cf.internal:8443/ \
      --cacert certificates/ca.crt          \
      --cert certificates/bits-service.crt  \
      --key certificates/bits-service.key
  ```

  This one must fail due to `VERIFY_FAIL_IF_NO_PEER_CERT`:

  ```bash
  curl https://cc.service.cf.internal:8443/ --cacert certificates/ca.crt
  ```

# Certificate Rotation

TBD
