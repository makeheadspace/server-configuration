postgresql:
  pkg.installed

/etc/postgresql/9.1/main/pg_hba.conf:
  file.managed:
    - source: salt://devenvironment/postgres/pg_hba.conf
    - user: postgres
    - group: postgres
    - mode: 640
