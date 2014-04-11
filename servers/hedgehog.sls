include:
  - common
  - minecraft-server

/etc/salt/minion:
  file.managed:
    - source: salt://servers/hedgehog/minion-config
