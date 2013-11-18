include:
  - postgresql92-server
  - rbenv
  - nginx

{% for app in pillar['rack-apps'].values() %}

{{ app['name'] }}:
  user.present:
    - shell: /bin/bash
  postgres_database.present:
    - runas: postgres
    - owner: {{ app['name'] }}
    - require:
      - postgres_user: {{ app['name'] }}
  postgres_user.present:
    - encrypted: true
    - password: {{ app['postgresql_password'] }}
    - require:
      - user: {{ app['name'] }}
      - service: postgresql-9.2
  git.latest:
    - name: {{ app['git_url'] }}
    - runas: {{ app['name'] }}
    - rev: {{ app['revision'] }}
    - target: /home/{{ app['name'] }}/application
    - require:
      - user: {{ app['name'] }}
  service.running:
    - require:
      - file: /etc/init/{{ app['name'] }}.conf
      - cmd: {{ app['name'] }}-migrate-database
      - service: postgresql-9.2

/home/{{ app['name'] }}/.bashrc:
  file.append:
    - user: {{ app['name'] }}
    - require:
      - rbenv: {{ app['name'] }}-ruby
      - user: {{ app['name'] }}
    - text:
      - PATH=$HOME/.rbenv/shims:$HOME/.rbenv/bin/:$PATH
      - eval "$(rbenv init -)"

{{ app['name'] }}-ruby:
  rbenv.installed:
    - name: 2.0.0-p247
    - user: {{ app['name'] }}
    - default: True
    - require:
      - pkg: rbenv-deps
      - user: {{ app['name'] }}

{{ app['name'] }}-bundler:
  cmd.wait:
    - cwd: /home/{{ app['name'] }}/application
    - user: {{ app['name'] }}
    - name: gem install bundler && rbenv rehash && bundle install --deployment
    - require:
      - file: /home/{{ app['name'] }}/.bundle/config
      - rbenv: {{ app['name'] }}-ruby
    - watch:
      - git: {{ app['name'] }}

{{ app['name'] }}-migrate-database:
  cmd.wait:
    - cwd: /home/{{ app['name'] }}/application
    - user: {{ app['name'] }}
    - name: bin/rake authifer:db:migrate
    - require:
      - file: /home/{{ app['name'] }}/application/.env
    - watch:
      - cmd: {{ app['name'] }}-bundler
      
/home/{{ app['name'] }}/.bundle/config:
  file.managed:
    - user: {{ app['name'] }}
    - group: {{ app['name'] }}
    - source: salt://rack-app/bundle-config
    - require:
      - user: {{ app['name'] }}

/home/{{ app['name'] }}/application/.env:
  file.managed:
    - user: {{ app['name'] }}
    - group: {{ app['name'] }}
    - source: salt://apps/{{ app['name'] }}/dotenv
    - template: jinja
    - context:
      port: {{ app['port'] }}
      app: {{ app['name'] }}
    - require:
      - git: {{ app['name'] }}

/etc/init/{{ app['name'] }}.conf:
  file.managed:
    - source: salt://rack-app/upstart
    - template: jinja
    - context:
      app: {{ app['name'] }}
      command: {{ app['run_command'] }}


/etc/nginx/conf.d/{{ app['name'] }}.conf:
  file.managed:
    - user: {{ app['name'] }}
    - group: {{ app['name'] }}
    - source: salt://rack-app/nginx-conf
    - template: jinja
    - context:
      port: {{ app['port'] }}
      app: {{ app['name'] }}
      hostname: {{ app['hostname'] }}

extend:
  nginx:
    service:
      - watch:
        - file: /etc/nginx/conf.d/{{ app['name'] }}.conf
{% endfor %}
