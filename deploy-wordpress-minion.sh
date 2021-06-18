#!/usr/bin/env bash

echo "Please enter the hostname or IP address of the new minion"
read -r host_name

echo "Please enter the administrator account of the new minion"
read -r account_name

# Run remote command on minion
ssh -t $account_name@$host_name "sudo apt install curl; curl -L https://bootstrap.saltstack.com -o install_salt.sh ~/; sudo sh ~/install_salt.sh; sudo sed -i \"s/#master: salt/master: SWMaster/\" /etc/salt/minion; sudo systemctl restart salt-minion"

# Sleep for 5 seconds to give to minion time to announce itself
sleep 5

# Accept new salt-key
sudo salt-key --accept-all -y

# Sleep 10 seconds for having a proper connection between master and minion
sleep 10

# Apply minion salt state
sudo salt '*wordpress[0-9]*' state.apply wordpress-node

# Updating database permissions and wordpress config.php
ssh -t $account_name@$host_name "sudo mysql -u root -e 'GRANT ALL ON wordpress.* TO wordpress@localhost;'; sudo mv /etc/wordpress/config-localhost.php /etc/wordpress/config-$host_name.php"

# Update munin.conf
sudo host_name=$host_name bash -c '
echo -e "
[SWNodes;$host_name]
    address $host_name
    use_node_name yes" >> /etc/munin/munin.conf'
