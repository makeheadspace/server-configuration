/etc/salt/minion:
  file.managed:
    - source: salt://servers/prime/minion-config
/etc/ssh/sshd_config:
  file.managed:
    - source: salt://servers/hedgehog/sshd-config
