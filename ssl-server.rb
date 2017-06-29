#!/usr/local/bin/ruby

# based on http://www.networkworld.com/article/2285193/infrastructure-management/creating-an-ssl-certificate-for-webrick.html

require 'webrick'
require 'webrick/https'
require 'openssl'

key = OpenSSL::PKey::RSA.new(File.read('certificates/server.key'))
cert = OpenSSL::X509::Certificate.new(File.read('certificates/server.crt'))

s = WEBrick::HTTPServer.new(
  :Port => 8443,
  :Logger => WEBrick::Log::new($stderr, WEBrick::Log::DEBUG),
  :DocumentRoot => "docs",
  :SSLEnable => true,
  :SSLVerifyClient => OpenSSL::SSL::VERIFY_PEER | OpenSSL::SSL::VERIFY_FAIL_IF_NO_PEER_CERT,
  :SSLCACertificateFile => 'certificates/ca.crt',
  :SSLCertificate => cert,
  :SSLPrivateKey => key,
  :SSLCertName => [ [ 'CN', 'cc.service.cf.internal' ] ]
)

s.start

__END__

Test on a Linux system:

curl https://cc.service.cf.internal:8443/ \
    --cacert certificates/ca.crt \
    --cert certificates/bits-service.crt \
    --key certificates/bits-service.key

This one must fail due to VERIFY_FAIL_IF_NO_PEER_CERT:

curl https://cc.service.cf.internal:8443/ \
    --cacert certificates/ca.crt
