include:
  - users.zee.ssh

zee:
  user.present:
    - fullname: "Zee Spencer"
    - password: '{{ pillar["zee"]["password_shadow"] }}'
    - shell: /bin/bash
    - groups:
      - wheel
    - remove_groups: false

/home/zee/.vimrc:
  file.managed:
    - name: /home/zee/.vimrc
    - user: zee
    - group: zee
    - source: salt://users/zee/vimrc
    - replace: false
    - require:
      - user: zee
