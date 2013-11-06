base:
  'roles:devenvironment':
    - match: grain
    - common.pkgs
    - users.zee
    - users.strand
    - devenvironment
    - devenvironment.postgres
    - devenvironment.rvm
    - devenvironment.desksnearme
  'roles:gitserver':
    - match: grain
    - common.pkgs
    - gitserver
  'roles:discourseserver':
    - match: grain
    - common.pkgs
    - users.zee
    - apps.discourse
  'roles:saltminion':
    - match: grain
    - saltminion
  'nodename:hedgehog.makeheadspace.com':
    - match: grain
    - users.strand
    - servers.hedgehog
