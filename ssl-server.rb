#!/usr/local/bin/ruby

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
  :SSLCertName => [ [ 'CN', 'cc.service.cf.internal' ] ] # must match the server name (both physically and as CN in the server certificate)
)

s.start
