#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive
curl -s -O https://apt.puppetlabs.com/puppetlabs-release-pc1-xenial.deb
dpkg -i puppetlabs-release-pc1-xenial.deb
apt-get update
apt-get install puppet -y
puppet module install maestrodev-wget
puppet module install puppetlabs-mysql --version 3.11
