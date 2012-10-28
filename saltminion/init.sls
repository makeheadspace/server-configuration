salt-minion:
  pkg.latest
  service.running:
    - watch:
      - file: /etc/salt/minion
