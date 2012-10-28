desksnearme-deps:
  pkg.installed:
    - names:
      - imagemagick
      - postgresql
      - sphinxsearch
      - libpq-dev

git@github.com:mydy-dev/desksnearme.git:
  git.latest:
    - rev: master
    - target: /home/zee/Projects/desksnearme
    - runas: zee
