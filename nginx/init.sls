nginx:
  pkg:
    - installed
    - require:
      - file: /etc/yum/repos.d/nginx.repo
  service:
    - running
    - require:
      - pkg: nginx

/etc/nginx/nginx.conf:
  file.managed:
    - source: salt://nginx/nginx-conf

/etc/yum/repos.d/nginx.repo:
  file.managed:
    - source: salt://nginx/repo
