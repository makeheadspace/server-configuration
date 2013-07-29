include:
  - nginx
  - redis
  - rbenv
  - postgresql92-server
 
discourse:
  user.present:
    - fullname: "Discourse Server"
    - shell: /bin/bash
  postgres_database.present:
    - runas: postgres
    - owner: discourse
    - require:
      - postgres_user: discourse
  postgres_user.present:
    - encrypted: true
    - password: {{ pillar["discourse"]["postgresql_password"] }}
    - superuser: true
    - require:
      - user: discourse
  git.latest:
    - name: https://github.com/discourse/discourse.git
    - runas: discourse
    - rev: v0.9.5.1
    - target: /home/discourse/application
    - require:
      - rbenv: ruby-2.0.0-p247
      - pkg: discourse-deps
      - user: discourse
  file.append:
    - runas: discourse
    - name: /home/discourse/.bashrc
    - require:
      - user: discourse
    - text:
      - PATH=$HOME/.rbenv/shims:$HOME/.rbenv/bin/:$PATH
      - eval "$(rbenv init -)"
  service.running:
    - name: discourse
    - watch:
      - cmd: discourse-install-service
    - require:
      # - service: postgresql-9.2 # This fails on centos 6.4 :(
      - service: redis
      - service: nginx


/home/discourse/application/.env:
  file.managed:
    - user: discourse
    - group: discourse
    - source: salt://apps/discourse/dotenv
    - template: jinja
    - require:
      - git: discourse

/home/discourse/application/config/environments/production.rb:
  file.managed:
    - user: discourse
    - group: discourse
    - source: salt://apps/discourse/production-config.rb
    - require:
      - git: discourse

/home/discourse/application/config/redis.yml:
  file.managed:
    - user: discourse
    - group: discourse
    - source: salt://apps/discourse/redis-config.yml
    - require:
      - git: discourse

/home/discourse/application/Procfile:
  file.managed:
    - user: discourse
    - group: discourse
    - source: salt://apps/discourse/Procfile
    - require:
      - git: discourse

/home/discourse/application/config/unicorn.conf.rb:
  file.managed:
    - user: discourse
    - group: discourse
    - source: salt://apps/discourse/unicorn-config.rb
    - require:
      - git: discourse

/home/discourse/application/config/database.yml:
  file.managed:
    - user: discourse
    - group: discourse
    - source: salt://apps/discourse/database-config.yml
    - template: jinja
    - require:
      - git: discourse

discourse-install-service:
  cmd.wait:
    - name: cp -r /home/discourse/init/* /etc/init/
    - watch:
      - cmd: discourse-foreman

ruby-2.0.0-p247:
  rbenv.installed:
    - runas: discourse
    - default: True
    - require:
      - pkg: rbenv-deps
      - user: discourse

  
discourse-deps:
  pkg.installed:
    - pkgs:
      - libxml2
      - libxml2-devel
      - libxslt
      - libxslt-devel
      - postgresql92-devel
      - postgresql92-contrib
      - gperftools-libs
# For some reason this fails, even though the package exists.
#      - gcc-g++
    - require:
      - pkg: postgresql92-server

/home/discourse/.bundle/config:
  file.managed:
    - user: discourse
    - group: discourse
    - source: salt://apps/discourse/bundle-config
    - require:
      - user: discourse

discourse-bundler:
  cmd.wait:
    - cwd: /home/discourse/application
    - user: discourse
    - name: gem install bundler && rbenv rehash && bundle install --deployment --without test
    - require:
      - file: /home/discourse/.bundle/config
    - watch:
      - git: discourse

discourse-foreman:
  cmd.wait:
    - cwd: /home/discourse/application
    - user: discourse
    - name: gem install foreman && rbenv rehash && foreman export upstart ~/init -a discourse -l ~/logs -p 4000
    - watch:
      - cmd: discourse-bundler
      - file: /home/discourse/application/config/redis.yml
      - file: /home/discourse/application/.env
      - file: /home/discourse/application/config/database.yml
      - file: /home/discourse/application/Procfile
      - file: /home/discourse/application/config/environments/production.rb
      - file: /home/discourse/application/config/unicorn.conf.rb
