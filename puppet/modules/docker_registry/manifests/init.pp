# Class: docker_registry
#
# This module manages docker_registry
#
# Parameters: None
#
# Actions: None
#
# Requires: None
#   - The java::jdk8 module
#
# Sample Usage: include bitbucket
#
class docker_registry () {
require users::teamcityagent
  class {
    'nginx':
      nginx_package      => 'nginx',
      worker_connections => 65536,
      worker_priority    => 0,
      worker_processes   => $::processorcount,
      ssl_truncation     => $ssl_truncation,
  }

  file {
  '/etc/nginx/ssl/cert/ignitionone.com.crt':
    source => 'puppet:///puppet_dir_master/systems/_LINUX_/etc/nginx/ssl/cert/ignitionone.com.crt',
    owner => 'root',
    group  => 'root',
    mode   => '0644',
    #require => Package['nginx'],
    require => File['/etc/nginx/ssl/cert'],
    notify => Service['nginx'];
  '/etc/nginx/ssl/key/ignitionone.com.rsa':
   source => 'puppet:///puppet_dir_master/systems/_LINUX_/etc/nginx/ssl/key/private/ignitionone.com.rsa',
    owner => 'root',
    group  => 'root',
    mode   => '0644',
    #require => Package['nginx'],
    require => File['/etc/nginx/ssl/key'],
    notify => Service['nginx'];
  }

}
