zee:
  user.present:
    - fullname: Zee Spencer
    - shell: /bin/bash
    - groups:
      - rvm
      - sudo
  postgres_user.present:
    - createdb: true
    - superuser: true
    - runas: postgres
  file.directory:
    - name: /home/zee/Projects
    - user: zee
    - group: zee

common-deps:
  pkg.installed:
    - names:
      - xvfb
      - firefox
      - tmux
      - vim
      - nodejs
      - gnuplot
