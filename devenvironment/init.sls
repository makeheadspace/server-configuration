zee:
  user.present:
    - fullname: Zee Spencer
    - shell: /bin/bash
    - groups:
      - rvm
      - sudo
    - require:
      - group: rvm
