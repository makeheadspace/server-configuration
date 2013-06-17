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
    - optional_groups:
      - sudo
      - wheel
      - rvm
    - remove_groups: false
