include:
  - common
  - apps.authnmakeheadspace

/etc/salt/minion:
  file.managed:
    - source: salt://servers/hedgehog/minion-config
