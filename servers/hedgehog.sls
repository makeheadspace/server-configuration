/etc/salt/minion:
  file.managed:
    - source: salt://servers/hedgehog/minion-config 
/etc/ssh/sshd_config:
  file.managed:
    - source: salt://servers/hedgehog/sshd-config

/etc/sudoers:
  file.append:
    - text: "%wheel        ALL=(ALL)       ALL"
