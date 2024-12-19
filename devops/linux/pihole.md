
* 目前清單
pihole -g -l

* 手動阻擋
pihole -b analytics.nownews.com
nslookup analytics.nownews.com localhost

* Ansible
---
- name: Copy and Run shell scripts on remote machine
  vars_prompt:
    - name: host
      prompt: What is your host?
      private: no
      
  hosts: '{{ host }}'
  become: yes
  vars:
    pihole_interface: eth0
    pihole_dns_1: 8.8.8.8
    pihole_dns_2: 8.8.4.4
    ipv4_address: "{{ hostvars[inventory_hostname]['ansible_host'] }}/24"

  tasks:
    - name: Create Pi-hole configuration file
      copy:
        content: |
          PIHOLE_INTERFACE={{ pihole_interface }}
          IPV4_ADDRESS={{ ipv4_address }}
          PIHOLE_DNS_1={{ pihole_dns_1 }}
          PIHOLE_DNS_2={{ pihole_dns_2 }}
          QUERY_LOGGING=true
          INSTALL_WEB_SERVER=false
          INSTALL_WEB_INTERFACE=false
          LIGHTTPD_ENABLED=false
          CACHE_SIZE=10000
          DNS_FQDN_REQUIRED=true
          DNS_BOGUS_PRIV=true
          DNSMASQ_LISTENING=local
          BLOCKING_ENABLED=true
        dest: /etc/pihole/setupVars.conf
        mode: '0644'

    - name: Download Pi-hole installer
      get_url:
        url: https://install.pi-hole.net
        dest: /tmp/pihole_installer.sh
        mode: '0700'

    - name: Run Pi-hole installer
      command: bash /tmp/pihole_installer.sh --unattended
      args:
        creates: /usr/local/bin/pihole

    - name: Remove installer script
      file:
        path: /tmp/pihole_installer.sh
        state: absent

    - name: Ensure Pi-hole is updated and gravity list is updated
      command: pihole -up
      changed_when: false


