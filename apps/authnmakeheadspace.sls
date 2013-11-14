include: 
  - postgresql92-server
  - rbenv
  - nginx

authnmakeheadspace:
  user.present:
    - shell: /bin/bash
  postgres_database.present:
    - runas: postgres
    - owner: authnmakeheadspace
    - require:
      - postgres_user: authnmakeheadspace
  postgres_user.present:
    - encrypted: true
    - password: {{ pillar["authnmakeheadspace"]["postgresql_password"] }}
    - require:
      - user: authnmakeheadspace
      - service: postgresql-9.2
  git.latest:
    - name: https://github.com/makeheadspace/authn.makeheadspace.com.git
    - runas: authnmakeheadspace
    - rev: master
    - target: /home/authnmakeheadspace/application
    - require:
      - user: authnmakeheadspace
  file.append:
    - user: authnmakeheadspace
    - name: /home/authnmakeheadspace/.bashrc
    - require:
      - rbenv: authnmakeheadspace-ruby
      - user: authnmakeheadspace
    - text:
      - PATH=$HOME/.rbenv/shims:$HOME/.rbenv/bin/:$PATH
      - eval "$(rbenv init -)"
  service.running:
    - require:
      - file: /etc/init/authnmakeheadspace.conf
      - cmd: authnmakeheadspace-migrate-database
      - service: postgresql-9.2


authnmakeheadspace-ruby:
  rbenv.installed:
    - name: 2.0.0-p247
    - user: authnmakeheadspace
    - default: True
    - require:
      - pkg: rbenv-deps
      - user: authnmakeheadspace


authnmakeheadspace-bundler:
  cmd.wait:
    - cwd: /home/authnmakeheadspace/application
    - user: authnmakeheadspace
    - name: gem install bundler && rbenv rehash && bundle install --deployment --without test,development
    - require:
      - file: /home/authnmakeheadspace/.bundle/config
      - rbenv: authnmakeheadspace-ruby
    - watch:
      - git: authnmakeheadspace

authnmakeheadspace-migrate-database:
  cmd.wait:
    - cwd: /home/authnmakeheadspace/application
    - user: authnmakeheadspace
    - name: bin/rake authifer:db:migrate
    - require:
      - file: /home/authnmakeheadspace/application/.env
    - watch:
      - cmd: authnmakeheadspace-bundler


/home/authnmakeheadspace/.bundle/config:
  file.managed:
    - user: authnmakeheadspace
    - group: authnmakeheadspace
    - source: salt://apps/authnmakeheadspace/bundle-config
    - require:
      - user: authnmakeheadspace

/home/authnmakeheadspace/application/.env:
  file.managed:
    - user: authnmakeheadspace
    - group: authnmakeheadspace
    - source: salt://apps/authnmakeheadspace/dotenv
    - template: jinja
    - require:
      - git: authnmakeheadspace

/etc/init/authnmakeheadspace.conf:
  file.managed:
    - source: salt://apps/authnmakeheadspace/upstart

/etc/nginx/conf.d/authnmakeheadspace.conf:
  file.managed:
    - user: authnmakeheadspace
    - group: authnmakeheadspace
    - source: salt://apps/authnmakeheadspace/nginx-conf

extend:
  nginx:
    service:
      - watch:
        - file: /etc/nginx/conf.d/authnmakeheadspace.conf
