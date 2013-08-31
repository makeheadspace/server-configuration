/etc/yum/repos.d/pgdg-92-centos.repo:
  file.managed:
    - source: salt://postgresql92-server/repo

/etc/pki/rpm-gpg/RPM-GPG-KEY-PGDG-92:
  file.managed:
    - source: salt://postgresql92-server/repo-gpg

postgresql92-server:
  pkg:
    - installed
    - require:
      - file: /etc/yum/repos.d/pgdg-92-centos.repo
      - file: /etc/pki/rpm-gpg/RPM-GPG-KEY-PGDG-92
  service:
    - name: postgresql-9.2
    - running
    - require:
      - pkg: postgresql92-server
  cmd.wait:
    - name: service postgresql-9.2 initdb
    - watch:
      - pkg: postgresql92-server
