check_node_packages:
  pkg.installed:
    - pkgs:
      - apt-transport-https
      - qemu-guest-agent
      - curl
      - ca-certificates
      - gnupg
      - lsb-release
      - wget
      - rsyslog
      - apache2
      - munin-node

get_repo_docker_key:
  cmd.run:
    - name: curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key --keyring /etc/apt/trusted.gpg.d/docker-apt-key.gpg add

get_repo_docker:
  pkgrepo.managed:
    - humanname: Docker - Stable
    - name: deb https://download.docker.com/linux/debian   buster stable
    - file: /etc/apt/sources.list.d/docker.list

get_docker:
  pkg.installed:
    - pkgs:
      - docker-ce
      - docker-ce-cli
      - containerd.io

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

restart_munin-node:
  cmd.run:
    - name: systemctl restart munin-node

restart_apache2:
  cmd.run:
    - name: systemctl restart apache2

restart_rsyslog:
  cmd.run:
    - name: systemctl restart rsyslog

status_munin-node:
  cmd.run:
    - name: systemctl status munin-node

status_apache2:
  cmd.run:
    - name: systemctl status apache2

status_rsyslog:
  cmd.run:
    - name: systemctl status rsyslog

status_docker:
  cmd.run:
    - name: docker run hello-world
