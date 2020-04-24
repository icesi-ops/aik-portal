#!/bin/bash
        #sudo yum update -y
        #sudo yum install -y git 
        #Clone salt repo
        #git clone https://github.com/icesi-ops/training_IaC /srv/Configuration_management

        #Install Salstack
        sudo yum install -y https://repo.saltstack.com/yum/redhat/salt-repo-latest.el7.noarch.rpm
        sudo yum clean expire-cache;sudo yum -y install salt-minion; chkconfig salt-minion off
        
        #Install Ruby


        #Put custom minion config in place (for enabling masterless mode)
        #sudo cp -r /srv/Configuration_management/SaltStack/minion.d /etc/salt/
        echo -e 'grains:\n roles:\n  - frontend' > /etc/salt/minion.d/grains.conf

        ## Trigger a full Salt run
        #sudo salt-call state.apply

        