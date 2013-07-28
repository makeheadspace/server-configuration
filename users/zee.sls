include:
  - users.zee.ssh
zee:
  user.present:
    - fullname: "Zee Spencer"
    - shell: /bin/bash
    - optional_groups:
      - sudo
      - wheel
      - rvm
    - remove_groups: false

/home/zee/.vimrc:
  file.managed:
    - name: /home/zee/.vimrc
    - source: salt://users/zee/vimrc
    - replace: false
