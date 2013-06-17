devenvironment:
  postgres_database.present:
    - name: zee
    - runas: postgres
  postgres_user.present:
    - name: zee
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
