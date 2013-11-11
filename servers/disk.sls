include:
  - common

/etc/salt/minion:
  file.managed:
    - source: salt://servers/disk/minion-config
