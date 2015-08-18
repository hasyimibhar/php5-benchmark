#!/bin/sh

sudo apt-get update
sudo apt-get install -y puppet
sudo LC_ALL=en_US.UTF-8 \
    FACTER_hiera_data_dir=/home/ubuntu/puppet/hiera \
    FACTER_user=ubuntu \
    puppet apply \
    --modulepath /home/ubuntu/puppet/modules \
    --hiera_config /home/ubuntu/puppet/hiera.yaml \
    /home/ubuntu/puppet/manifests/init.pp
