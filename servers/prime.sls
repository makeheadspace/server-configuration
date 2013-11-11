include:
  - common
  - ircclient
  - gitserver

/etc/salt/minion:
  file.managed:
    - source: salt://servers/prime/minion-config
