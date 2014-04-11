minecraft_server:
  user.present:
    - shell: /bin/bash
  service.running:
    - require:
      - file: /etc/init/minecraft_server.conf

/etc/init/minecraft_server.conf:
  file.managed:
    - user: minecraft_server
    - group: minecraft_server
    - source: salt://minecraft-server/upstart
    - require: 
      - pkg: java-1.7.0-openjdk


java-1.7.0-openjdk:
  pkg.installed

