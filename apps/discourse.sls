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
      - service: postgresql-9.2
  git.latest:
    - name: https://github.com/discourse/discourse.git
    - runas: discourse
    - rev: v0.9.5.1
    - target: /home/discourse/application
    - require:
      - user: discourse
  file.append:
    - runas: discourse
    - name: /home/discourse/.bashrc
    - require:
      - rbenv: ruby-2.0.0-p247
      - user: discourse
    - text:
      - PATH=$HOME/.rbenv/shims:$HOME/.rbenv/bin/:$PATH
      - eval "$(rbenv init -)"
  service.running:
    - require:
      - rbenv: ruby-2.0.0-p247
      - pkg: discourse-deps
      - file: /etc/init/discourse.conf
      - cmd: discourse-bundler
      - service: postgresql-9.2
      - service: redis
      - service: nginx
      - cmd: gem install foreman

/home/discourse:
  file.directory:
    - mode: 711
    - require: 
      - user: discourse

/home/discourse/application/public:
  file.directory:
    - mode: 755
    - recurse:
      - mode
    - require:
      - git: discourse

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

/etc/nginx/conf.d/discourse.conf:
  file.managed:
    - user: discourse
    - group: discourse
    - source: salt://apps/discourse/nginx-conf

extend:
  nginx:
    service:
      - watch:
        - file: /etc/nginx/conf.d/discourse.conf


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
      - gcc-c++

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

gem install foreman:
  cmd.wait:
    - user: discourse
    - watch:
      - file: /home/discourse/.bashrc

/etc/init/discourse.conf:
  file.managed:
    - source: salt://apps/discourse/upstart
