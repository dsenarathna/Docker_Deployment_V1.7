# Class: bitbucket
#
# This module manages bitbucket
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
class bitbucket () {

  include git
  $package_git = hiera('package_git')

  class {
    'nginx':
      nginx_package      => 'nginx',
      worker_connections => 65536,
      worker_priority    => 0,
      worker_processes   => $::processorcount,
      ssl_truncation     => $ssl_truncation,
  }

  file {
   '/etc/nginx/sites-available/bitbucket.ignitionone.com.conf':
     source => 'puppet:///puppet_dir_master/systems/_LINUX_/etc/nginx/sites-available/bitbucket.ignitionone.com',
     owner  => 'root',
     group  => 'root',
     mode   => '0644',
     #require => Package['nginx'],
     require => File['/etc/nginx/sites-available'],
     notify => Service['nginx'];
  '/etc/nginx/sites-available/stash.ignitionone.com.conf':
     source => 'puppet:///puppet_dir_master/systems/_LINUX_/etc/nginx/sites-available/stash.ignitionone.com',
     owner  => 'root',
     group  => 'root',
     mode   => '0644',
     #require => Package['nginx'],
     require => File['/etc/nginx/sites-available'],
     notify => Service['nginx'];
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
  } ->

  file {
    '/etc/nginx/sites-enabled/bitbucket.ignitionone.com.conf':
      ensure => link,
      target => '/etc/nginx/sites-available/bitbucket.ignitionone.com.conf',
      #require => Package['nginx'],
      require => File['/etc/nginx/sites-available'],
      notify => Service['nginx'];
    '/etc/nginx/sites-enabled/stash.ignitionone.com.conf':
      ensure => link,
      target => '/etc/nginx/sites-available/stash.ignitionone.com.conf',
      #require => Package['nginx'],
      require => File['/etc/nginx/sites-available'],
      notify => Service['nginx'],
  } ->

  package { 'postgresql':
    ensure => latest;
  }
  package { 'bitbucket':
    ensure => latest,
    require => [Package[$package_git]]
  }
}
