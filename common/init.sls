commonpkgs:
  pkg.installed:
    - pkgs:
      - vim
      - tmux
      - htop

zee:
  user.present:
    - fullname: "Zee Spencer"
    - shell: /bin/bash
    - optional_groups:
      - sudo
      - wheel
      - rvm
    - remove_groups: false
  file.managed:
    - source: salt://common/vimrc
    - name: /home/zee/.vimrc
    - user: zee
    - group: zee
