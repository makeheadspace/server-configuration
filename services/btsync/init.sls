{% for user in pillar['btsync']['users'].values() %}

btsync-{{ user['name'] }}-user: 
  user.present:
    - name: {{ user['name'] }}
    - remove_groups: false

/etc/init.d/btsync-{{ user['name']}}:
  file.managed:
    - source: salt://services/btsync/service
    - template: jinja
    - mode: 755
    - context: 
      user: {{ user['name'] }}

/home/{{ user['name'] }}/.sync:
  file.directory:
    - user: {{  user['name'] }}
    - group: {{  user['name'] }}

/home/{{ user['name'] }}/.btsync-config:
  file.serialize:
    - user: {{  user['name'] }}
    - group: {{  user['name'] }}
    - dataset:
        webui:
          listen: 0.0.0.0:{{ user['port'] }}
          login: {{ user['name'] }}
          password: {{ user['password'] }}
        device_name: {{ user['name'] }}  - disk.makeheadspace.com
        storage_path: /home/{{ user['name'] }}/.sync
        listening_port: 0
        check_for_updates: true
        use_upnp: true
        download_limit: 0
        upload_limit: 0
    - formatter: json
     


btsync-{{ user['name'] }}:
  service.running:
    - require:
      - file: /etc/init.d/btsync-{{ user['name'] }}
      - file: /usr/local/bin/btsync
      - file: /home/{{ user['name'] }}/.sync
    - watch:
      - file: /home/{{ user['name'] }}/.btsync-config

{% endfor %}

/usr/local/bin/btsync:
  file.managed:
    - source: salt://services/btsync/binary
    - mode: 755

