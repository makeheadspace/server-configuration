postgresql-server:
  pkg:
    - installed
  service:
    - name: postgresql
    - running
    - require:
      - pkg: postgresql-server
