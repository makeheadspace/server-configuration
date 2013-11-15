include:
  - users.zee
  - saltminion

/etc/ssh/sshd_config:
  file.managed:
    - source: salt://common/ssh/sshd-config

/etc/sudoers:
  file.append:
    - text: "%wheel        ALL=(ALL)       ALL"

common-pkgs:
  pkg.installed:
    - pkgs:
      - vim-enhanced
      - tmux
      - htop
      - git

ntpd:
  service:
    - running
    - enable: True

time-sync:
  pkg.installed:
    - pkgs:
      - ntp
      - ntpdate
