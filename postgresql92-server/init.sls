postgresql-repo:
  cmd.run:
    - name: "rpm -ivh http://yum.pgrpms.org/9.2/redhat/rhel-6-x86_64/pgdg-centos92-9.2-6.noarch.rpm --replacepkgs"
  
postgresql92-server:
  pkg:
    - installed
    - require:
      - cmd: postgresql-repo
    - require_in:
      - cmd: postgresql92-server
  service:
    - name: postgresql-9.2
    - running
    - require:
      - pkg: postgresql92-server
