salt-minion:
  pkg.latest:
    - name: salt-minion
  service.running:
    - watch:
      - file: /etc/salt/minion
