include:
  - common
  - services.btsync

/etc/salt/minion:
  file.managed:
    - source: salt://servers/disk/minion-config
