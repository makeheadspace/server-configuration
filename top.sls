base:
  'roles:devenvironment':
    - match: grain
    - common.pkgs
    - users.zee
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
  'roles:saltminion':
    - match: grain
    - saltminion
