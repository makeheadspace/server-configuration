vim:
  pkg.installed:
    - pkgs:
      - vim
      - tmux
      - htop
zee:
  user.present:
    - fullname: Zee Spencer
    - shell: /bin/bash
    - groups:
      - sudo
      - wheel
