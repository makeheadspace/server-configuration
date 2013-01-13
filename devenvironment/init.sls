zee:
  user.present:
    - groups:
      - rvm
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
      - nodejs
      - gnuplot
