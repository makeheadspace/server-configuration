include:
  - common
  - rack-app

/etc/salt/minion:
  file.managed:
    - source: salt://servers/hedgehog/minion-config
