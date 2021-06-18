check_node_packages:
  pkg.installed:
    - pkgs:
      - apt-transport-https
      - qemu-guest-agent
      - curl
      - wget
      - rsyslog
      - apache2
      - munin-node
      - wordpress
      - php
      - libapache2-mod-php
      - mariadb-server
      - mariadb-client
      - php-mysql
      - python-pip
      - python-mysqldb
      - python3-mysqldb

wordpress_database:
  mysql_database.present:
    - name: wordpress
  mysql_user.present:
    - name: wordpress
    - password: wordpress

push_munin-node.config:
  file.managed:
    - source: salt://munin-node.conf
    - name: /etc/munin/munin-node.conf
    - user: root
    - group: root
    - mode: 644

push_rsyslog.conf:
  file.managed:
    - source: salt://minion-rsyslog.conf
    - name: /etc/rsyslog.conf
    - user: root
    - group: root
    - mode: 644

push_wordpress.conf:
  file.managed:
    - source: salt://minion-wordpress.conf
    - name: /etc/apache2/sites-available/wordpress.conf
    - user: root
    - group: root
    - mode: 644

push_wordpress.php:
  file.managed:
    - source: salt://minion-wordpress.php
    - name: /etc/wordpress/config-localhost.php
    - user: root
    - group: root
    - mode: 644

s2ensite_wordpress:
  cmd.run:
    - name: sudo a2ensite wordpress

s2enmod_wordpress:
  cmd.run:
    - name: sudo a2enmod rewrite

restart_munin-node:
  cmd.run:
    - name: systemctl restart munin-node

restart_apache2:
  cmd.run:
    - name: systemctl restart apache2

restart_rsyslog:
  cmd.run:
    - name: systemctl restart rsyslog

restart_mysql:
  cmd.run:
    - name: service mariadb start

status_munin-node:
  cmd.run:
    - name: systemctl status munin-node

status_apache2:
  cmd.run:
    - name: systemctl status apache2

status_rsyslog:
  cmd.run:
    - name: systemctl status rsyslog